class_name WhiteBars extends Node2D


@onready var white_bars_camera_sound := $"White Bars Camera Sound"
@onready var white_bars_camera_animation := $"White Bars Camera Animation"

func _ready() -> void:
	white_bars_camera_animation.visible = false

func play() -> void:
	white_bars_camera_animation.visible = true
	white_bars_camera_animation.frame = 0
	white_bars_camera_animation.play("default")
	white_bars_camera_sound.play()
	
func stop() -> void:
	white_bars_camera_animation.stop()
	white_bars_camera_animation.visible = false

func _on_white_bars_camera_animation_animation_finished() -> void:
	stop()
