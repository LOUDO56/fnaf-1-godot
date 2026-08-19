extends AnimatedSprite2D

const FLICKER := 1.0

@onready var variant_timer := $"Variant Timer"

var current_flicker := 0.0

func _process(delta: float) -> void:
	current_flicker += delta
	if current_flicker >= FLICKER:
		current_flicker = 0.0
		if randf() < 0.4:
			variant_timer.start()
			frame = randi_range(1, sprite_frames.get_frame_count("default"))


func _on_variant_timer_timeout() -> void:
	variant_timer.stop()
	frame = 0
