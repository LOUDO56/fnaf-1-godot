class_name Chica extends Animatronic

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_7, CameraMap.Camera.CAM_6, CameraMap.Camera.CAM_4A],
	CameraMap.Camera.CAM_7:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_6:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_7],
	CameraMap.Camera.CAM_4A: [CameraMap.Camera.CAM_4B],
	CameraMap.Camera.CAM_4B: [CameraMap.Camera.CAM_4A, CameraMap.Camera.DOOR],
	CameraMap.Camera.DOOR:   [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_1B],
}

func move_ai() -> void:
	current_position = ROUTES[current_position].pick_random()
