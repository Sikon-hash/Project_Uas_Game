extends Node2D

@onready var character: Node = $TileMap/Character
@onready var try_again_button: Button = $CanvasLayer/TryAgainButton
@onready var healtbar: Control = $CanvasLayer/Healtbar

func _ready() -> void:
	try_again_button.visible = false
	try_again_button.pressed.connect(_on_try_again_pressed)

	if character and character.has_signal("died"):
		character.died.connect(_on_player_died)
	if character and character.has_signal("health_changed"):
		character.health_changed.connect(_on_player_health_changed)
		_on_player_health_changed(character.health, character.max_health)

func _on_player_died() -> void:
	try_again_button.visible = true

func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()

func _on_player_health_changed(current: int, max_health: int) -> void:
	if healtbar and healtbar.has_method("set_health"):
		healtbar.set_health(current, max_health)
