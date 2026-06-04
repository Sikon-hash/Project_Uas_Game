extends CharacterBody2D

const CHASE_SPEED = 60.0      # Kecepatan mengejar
const ATTACK_DISTANCE = 5.0   # Jarak sentuh untuk menyerang (piksel)
const ATTACK_COOLDOWN = 1.8    # Jeda antar serangan (detik)
const MAX_HEALTH = 30

var target_player: Node2D = null
var is_attacking: bool = false
var is_dead: bool = false
var is_hurt: bool = false
var health: int = MAX_HEALTH
var attack_cooldown_left: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox
var facing_dir: int = 1
var hitbox_base_x: float = 0.0

func _ready():
	if not is_in_group("enemy"):
		add_to_group("enemy")
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	hitbox_base_x = absf(hitbox.position.x)
	hitbox.disabled = true
	animated_sprite.play("idle")

func _physics_process(delta):
	if is_dead:
		return

	if attack_cooldown_left > 0.0:
		attack_cooldown_left = max(attack_cooldown_left - delta, 0.0)

	var current_target := _get_valid_target()

	# 1. Terapkan gravitasi jika tidak di lantai
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# 2. Logika gerak dan serangan (hanya jika tidak sedang menyerang)
	if not current_target or is_attacking:
		# Tidak ada target -> berhenti bergerak horizontal
		velocity.x = 0
		if not is_attacking and not is_hurt:
			animated_sprite.play("idle")
	else:
		var can_hit := current_target.has_method("get_hurtbox_global_rect") and _get_hitbox_global_rect().intersects(current_target.get_hurtbox_global_rect())
		if can_hit and attack_cooldown_left <= 0.0:
			attack()
			attack_cooldown_left = ATTACK_COOLDOWN
			velocity.x = 0
		
		# Kejar player
		if not is_attacking and not is_hurt:
			var arah = sign(current_target.global_position.x - global_position.x)
			if arah != 0:
				facing_dir = int(arah)
			velocity.x = arah * CHASE_SPEED
			animated_sprite.flip_h = arah < 0
			_update_hitbox_direction()
			animated_sprite.play("walk")
	
	# 3. Proses pergerakan dan tabrakan (termasuk gravitasi)
	move_and_slide()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		target_player = body
		print("Player detected!")

func _on_body_exited(body: Node2D):
	if body == target_player:
		target_player = null
		print("Player lost!")

func attack():
	if is_attacking or is_dead:
		return

	var current_target := _get_valid_target()
	if not current_target:
		return

	is_attacking = true
	velocity.x = 0
	
	if animated_sprite.sprite_frames.has_animation("att"):
		animated_sprite.play("att")
		if not animated_sprite.sprite_frames.get_animation_loop("att"):
			await animated_sprite.animation_finished
		else:
			await get_tree().create_timer(0.25).timeout
	else:
		animated_sprite.play("idle")

	var hit_target := _get_valid_target()
	if hit_target != null and hit_target.is_in_group("player") and hit_target.has_method("take_damage") and hit_target.has_method("get_hurtbox_global_rect") and _get_hitbox_global_rect().intersects(hit_target.get_hurtbox_global_rect()):
		hit_target.take_damage(3)
	
	is_attacking = false

func _get_valid_target() -> Node2D:
	if target_player == null:
		return null
	if not is_instance_valid(target_player):
		target_player = null
		return null
	return target_player

func take_damage(amount: int):
	if is_dead:
		return

	health -= amount
	print("Enemy kena damage! Health: ", health)

	if is_attacking:
		if health <= 0:
			die()
		return

	if animated_sprite.sprite_frames.has_animation("getting hit"):
		is_hurt = true
		animated_sprite.play("getting hit")
		await animated_sprite.animation_finished
		is_hurt = false

	if health <= 0:
		die()

func die():
	if is_dead:
		return

	is_dead = true
	is_attacking = false
	target_player = null
	velocity = Vector2.ZERO
	set_physics_process(false)

	if animated_sprite.sprite_frames.has_animation("dead"):
		animated_sprite.play("dead")
		await animated_sprite.animation_finished

	queue_free()

func _update_hitbox_direction() -> void:
	hitbox.position.x = hitbox_base_x * facing_dir

func _get_shape_half_extents(shape: Shape2D) -> Vector2:
	if shape is RectangleShape2D:
		return shape.size * 0.5
	if shape is CapsuleShape2D:
		return Vector2(shape.radius, shape.height * 0.5 + shape.radius)
	if shape is CircleShape2D:
		return Vector2(shape.radius, shape.radius)
	return Vector2(16.0, 16.0)

func _rect_from_collision_shape(shape_node: CollisionShape2D) -> Rect2:
	var half_extents := _get_shape_half_extents(shape_node.shape)
	return Rect2(shape_node.global_position - half_extents, half_extents * 2.0)

func _get_hitbox_global_rect() -> Rect2:
	return _rect_from_collision_shape(hitbox)

func get_hurtbox_global_rect() -> Rect2:
	return _rect_from_collision_shape(hurtbox)
