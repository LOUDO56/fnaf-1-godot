extends AnimatedSprite2D

const FLICKER := 0.8

@onready var variant_timer := $"Variant Timer"

var current_flicker := 0.0

func _process(delta: float) -> void:
	current_flicker += delta
	if current_flicker >= FLICKER:
		current_flicker = 0.0
		frame = 0
		var random_pose = randi_range(0, 99)
		if random_pose >= 1 and random_pose <= 3:
			variant_timer.start()
			frame = random_pose
			


func _on_variant_timer_timeout() -> void:
	frame = 0
