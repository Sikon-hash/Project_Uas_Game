extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D

var player_in_range: bool = false
var is_open: bool = false
var player: Node2D = null

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	animated_sprite.sprite_frames.set_animation_loop("gate open", false)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_open:
		open_gate()

func open_gate():
	is_open = true
	animated_sprite.play("gate open")
	await animated_sprite.animation_finished
	animated_sprite.pause()

	if player:
		player.visible = false

	get_tree().change_scene_to_file("res://Assets/Scenes/map_1.tscn")

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = true
		player = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = false
		player = null
