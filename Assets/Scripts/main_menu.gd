extends Node2D

@onready var play_sprite: AnimatedSprite2D = $Play
@onready var setting_sprite: AnimatedSprite2D = $Setting
@onready var exit_sprite: AnimatedSprite2D = $Exit

func _ready():
	$TitleCanvas/ShadowBladeTitle.add_theme_font_size_override("font_size", 48)

	_setup_button(play_sprite, func(): get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn"))
	_setup_button(setting_sprite, func(): pass)
	_setup_button(exit_sprite, func(): get_tree().quit())

func _setup_button(sprite: AnimatedSprite2D, action: Callable):
	var area: Area2D = sprite.get_node("Area2D")
	var anim_name = sprite.name
	var idle_name = anim_name + "_idle"

	area.mouse_entered.connect(func():
		if sprite.sprite_frames.has_animation(anim_name):
			sprite.play(anim_name))

	area.mouse_exited.connect(func():
		if sprite.sprite_frames.has_animation(idle_name):
			sprite.play(idle_name))

	area.input_event.connect(func(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			action.call())
