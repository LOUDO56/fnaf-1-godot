class_name WhiteBars extends Node2D


@onready var white_bars_camera_sound := $"White Bars Camera Sound"
@onready var white_bars_camera_animation := $"White Bars Camera Animation"

func _process(delta: float) -> void:
	pass

func start() -> void:
	visible = true
	white_bars_camera_animation.play()
	white_bars_camera_sound.play()
	
func stop() -> void:
	visible = false

func _on_white_bars_camera_animation_animation_finished() -> void:
	stop()
