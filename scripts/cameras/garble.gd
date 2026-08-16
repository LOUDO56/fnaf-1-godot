extends Node2D

@export var camera_switching: CameraSwitching
@export var garble_sprite: Sprite2D

@onready var camera_garble_sounds := [$"Camera Garble 1", $"Camera Garble 2", $"Camera Garble 3"]
@onready var garble_timer := $"Garble Timer"

func garble_camera() -> void:
	if camera_switching.current_camera == CameraMap.Camera.CAM_6:
		return
	garble_timer.start()
	camera_garble_sounds.pick_random().play()
	garble_sprite.visible = true
	camera_switching.reload_current_camera_sprite()

func _stop_garble_camera() -> void:	
	garble_sprite.visible = false
	garble_timer.stop()
	for camera_garble_sound in camera_garble_sounds:
		camera_garble_sound.stop()
	
func _on_garble_timer_timeout() -> void:
	_stop_garble_camera()

func _on_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	_stop_garble_camera()
