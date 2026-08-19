extends Sprite2D

const SPEED := 40.0

func _process(delta: float) -> void:
	position.y += SPEED * delta
	if position.y >= 720.0:
		position.y = -37.0
