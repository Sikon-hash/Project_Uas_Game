extends CanvasLayer

signal restart_pressed

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var area: Area2D = sprite.get_node("Area2D")

	area.mouse_entered.connect(func(): sprite.play("activated"))
	area.mouse_exited.connect(func(): sprite.play("idle"))
	area.input_event.connect(func(_v: Node, event: InputEvent, _i: int):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			restart_pressed.emit())
