class_name Bonnie extends Animatronic

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_5, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_5:  [CameraMap.Camera.CAM_2A, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_2A, CameraMap.Camera.CAM_5],
	CameraMap.Camera.CAM_2A: [CameraMap.Camera.CAM_3, CameraMap.Camera.CAM_2B],
	CameraMap.Camera.CAM_3:  [CameraMap.Camera.CAM_2A, CameraMap.Camera.DOOR],
	CameraMap.Camera.CAM_2B: [CameraMap.Camera.DOOR, CameraMap.Camera.CAM_3],
	CameraMap.Camera.DOOR:   [CameraMap.Camera.CAM_1B],
}

func move_ai() -> void:
	current_position = ROUTES[current_position].pick_random()
	if current_position == CameraMap.Camera.CAM_5:
		_easter_egg_bonnie_look_camera_backstage()

func _easter_egg_bonnie_look_camera_backstage() -> void:
	variant = 1 if randi() % 10 == 0 else 0
