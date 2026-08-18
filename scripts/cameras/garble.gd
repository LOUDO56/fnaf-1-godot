class_name GarbleEffect extends Node2D

@export var camera_switching: CameraSwitching
@export var garble_sprite: Sprite2D

@onready var camera_garble_sounds := $"Garble Sounds"
@onready var garble_timer := $"Garble Timer"

var garble_playing := false

func garble_camera() -> void:
	if camera_switching.current_camera == CameraMap.Camera.CAM_6:
		return
	garble_playing = true
	garble_timer.start()
	camera_garble_sounds.get_children().pick_random().play()
	garble_sprite.visible = true
	camera_switching.reload_current_camera_sprite()

func _stop_garble_camera(hide_garble := true) -> void:	
	if hide_garble:
		garble_playing = false
		garble_sprite.visible = false
		garble_timer.stop()
		for camera_garble_sound in camera_garble_sounds.get_children():
			camera_garble_sound.stop()
	else:
		for camera_garble_sound in camera_garble_sounds.get_children():
			camera_garble_sound.volume_db = -999.0

func _on_garble_timer_timeout() -> void:
	_stop_garble_camera()

func _on_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	_stop_garble_camera(false)

func _on_monitor_opened() -> void:
	for camera_garble_sound in camera_garble_sounds.get_children():
		camera_garble_sound.volume_db = 0.0
