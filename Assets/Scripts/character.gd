extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ATTACK_RANGE = 40.0
const ATTACK_DAMAGE = 10
const MAX_HEALTH = 100

signal died
signal health_changed(current: int, max: int)

@onready var animated_sprite: AnimatedSprite2D = $Animation
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox

var direction: float = 0.0
var facing_dir: int = 1
var is_attacking: bool = false
var health: int = MAX_HEALTH
var max_health: int = MAX_HEALTH
var is_dead: bool = false
var is_hurt: bool = false
var hitbox_base_x: float = 0.0

func _ready() -> void:
	if not is_in_group("player"):
		add_to_group("player")
	hitbox_base_x = absf(hitbox.position.x)
	hitbox.disabled = true
	animated_sprite.animation_finished.connect(_on_anim_finished)
	emit_signal("health_changed", health, max_health)

func _physics_process(delta: float) -> void:
	if is_dead:
		return  # jika mati, tidak lakukan apa pun
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_VELOCITY

	if not is_attacking:
		direction = Input.get_axis("left", "right")
		if direction != 0:
			facing_dir = -1 if direction < 0 else 1
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		direction = 0

	move_and_slide()
	_update_hitbox_direction()
	
	update_combat()
	update_animation()

func update_combat():
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_dead:
		is_attacking = true
		animated_sprite.play("att 1")
		await animated_sprite.animation_finished
		_deal_attack_damage()
		animated_sprite.play("att 2")
		await animated_sprite.animation_finished
		is_attacking = false

func _deal_attack_damage():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy == null or not is_instance_valid(enemy):
			continue
		if not (enemy is Node2D):
			continue
		if enemy.has_method("get_hurtbox_global_rect") and _get_hitbox_global_rect().intersects(enemy.get_hurtbox_global_rect()) and enemy.has_method("take_damage"):
			enemy.take_damage(ATTACK_DAMAGE)

func update_animation():
	if is_attacking or is_dead or is_hurt:
		return
		
	if not is_on_floor():
		if direction != 0:
			animated_sprite.flip_h = direction < 0
		if velocity.y < 0:
			animated_sprite.play("jumping")
		else:
			animated_sprite.play("falling")
	else:
		if direction != 0:
			animated_sprite.play("running")
			animated_sprite.flip_h = direction < 0
		else:
			animated_sprite.play("idle")

func take_damage(amount: int):
	if is_dead:
		return
	health -= amount
	health = max(health, 0)
	emit_signal("health_changed", health, max_health)
	print("Player terkena damage! Health: ", health)

	if health <= 0:
		die()
		return
	
	if is_attacking:
		return
	
	if animated_sprite.sprite_frames.has_animation("hurt"):
		is_hurt = true
		animated_sprite.play("hurt")

func die():
	if is_dead:
		return
	is_dead = true
	emit_signal("died")
	print("Player Mati!")
	set_physics_process(false)
	if animated_sprite.sprite_frames.has_animation("dead"):
		animated_sprite.play("dead")
	# Bisa juga reload scene atau tampilkan game over

func _update_hitbox_direction() -> void:
	hitbox.position.x = hitbox_base_x * facing_dir

func _get_shape_half_extents(shape: Shape2D) -> Vector2:
	if shape is RectangleShape2D:
		return shape.size * 0.5
	if shape is CapsuleShape2D:
		return Vector2(shape.radius, shape.height * 0.5 + shape.radius)
	if shape is CircleShape2D:
		return Vector2(shape.radius, shape.radius)
	return Vector2(ATTACK_RANGE * 0.5, ATTACK_RANGE * 0.5)

func _rect_from_collision_shape(shape_node: CollisionShape2D) -> Rect2:
	var half_extents := _get_shape_half_extents(shape_node.shape)
	return Rect2(shape_node.global_position - half_extents, half_extents * 2.0)

func _get_hitbox_global_rect() -> Rect2:
	return _rect_from_collision_shape(hitbox)

func _on_anim_finished():
	if animated_sprite.animation == "hurt":
		is_hurt = false

func get_hurtbox_global_rect() -> Rect2:
	return _rect_from_collision_shape(hurtbox)
