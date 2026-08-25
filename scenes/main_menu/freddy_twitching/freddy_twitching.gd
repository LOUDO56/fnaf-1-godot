extends AnimatedSprite2D

@onready var variant_timer := $"Variant Timer"

func _on_variant_timer_timeout() -> void:
	frame = 0
	var random_pose = randi_range(0, 99)
	if random_pose >= 1 and random_pose <= 3:
		frame = random_pose
