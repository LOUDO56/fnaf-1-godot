extends Node2D

signal head_flickering()
signal request_random_volume_voice()

@export var camera_switching: CameraSwitching

@onready var head_tilt_timer = $"Head Tilt Timer"
@onready var volume_robot_voice = $"Volume Robot Voice"

func _ready() -> void:
	if PlayerData.night >= 3:
		head_tilt_timer.start()
		volume_robot_voice.start()

func _on_heal_tilt_timer_timeout() -> void:
	if camera_switching.current_camera == CameraMap.Camera.CAM_4B \
	or camera_switching.current_camera == CameraMap.Camera.CAM_2B:
		head_flickering.emit()


func _on_volume_robot_voice_timeout() -> void:
	request_random_volume_voice.emit()
