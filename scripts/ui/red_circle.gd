extends Sprite2D

func _on_blink_timer_timeout() -> void:
	visible = not visible
