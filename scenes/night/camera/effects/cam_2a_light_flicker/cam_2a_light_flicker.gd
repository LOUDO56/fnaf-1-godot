extends Node2D

@export var camera_switching: CameraSwitching
@export var camera_sprites: CameraSprites

signal flicker_light_west_hall

const FLICKER_TIMER = 0.0167
var flicker_time: float

func _process(delta: float) -> void:
	flicker_time += delta
	if flicker_time >= FLICKER_TIMER:
		if camera_switching.current_camera == CameraMap.Camera.CAM_2A and randi_range(1, 10) >= 3:
			flicker_light_west_hall.emit()
		flicker_time = 0.0
