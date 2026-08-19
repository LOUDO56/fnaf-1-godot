extends Fade

func _fade_out() -> void:
	if fade_out or current_alpha < 1.0:
		return
	$ColorRect.visible = true
	super._fade_out()
