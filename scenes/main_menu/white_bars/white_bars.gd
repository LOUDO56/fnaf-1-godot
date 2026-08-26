extends AnimatedSprite2D

const FLICKER := 0.08

var current_flicker := 0.0

func _process(delta: float) -> void:
	current_flicker += delta
	if current_flicker >= FLICKER:
		current_flicker = 0.0
		visible = false
		if randf() < 0.4:
			visible = true
			frame = randi_range(0, sprite_frames.get_frame_count("default") - 1)
