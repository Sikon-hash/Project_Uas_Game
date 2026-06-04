extends Control

# Mengubah jalur ke node yang benar dan mengganti tipenya menjadi TextureProgressBar
@onready var health_bar: TextureProgressBar = $Panel/TextureProgressBar

func set_health(current: int, max_health: int) -> void:
	# Memastikan skrip tidak crash jika karena suatu alasan nodenya belum siap
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current
