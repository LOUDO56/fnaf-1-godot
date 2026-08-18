extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventKey and Input.is_key_pressed(KEY_ALT) and Input.is_key_pressed(KEY_ENTER):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if event is InputEventKey and Input.is_key_pressed(KEY_F11):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
