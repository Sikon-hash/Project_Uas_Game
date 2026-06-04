extends Control

@onready var health_bar: TextureProgressBar = $HealthBar

func set_health(current: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current
