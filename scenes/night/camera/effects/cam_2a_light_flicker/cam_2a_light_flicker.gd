extends Node2D

@export var camera_switching: CameraSwitching
@export var camera_sprites: CameraSprites

signal flicker_light_west_hall

const FLICKER_TIMER = 0.027
var flicker_time: float

func _process(delta: float) -> void:
	flicker_time += delta
	if flicker_time >= FLICKER_TIMER and camera_switching.current_camera == CameraMap.Camera.CAM_2A:
		flicker_light_west_hall.emit()
		flicker_time = 0.0
