extends ParallaxLayer

# Di Godot 4, gunakan @export tanpa tanda kurung untuk tipe datanya
@export var CLOUD_SPEED: float = -15.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.motion_offset.x += CLOUD_SPEED * delta
