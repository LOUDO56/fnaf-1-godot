class_name Bonnie extends Animatronic

func move_ai() -> void:
	match current_position:
		CameraMap.Camera.CAM_1A:
			if _fifty_fifty():
				_easter_egg_bonnie_look_camera_backstage()
				current_position = CameraMap.Camera.CAM_5
			else:
				current_position = CameraMap.Camera.CAM_1B
		CameraMap.Camera.CAM_5:
			if _fifty_fifty():
				current_position = CameraMap.Camera.CAM_2A
			else:
				current_position = CameraMap.Camera.CAM_1B
		CameraMap.Camera.CAM_1B:
			if _fifty_fifty():
				current_position = CameraMap.Camera.CAM_2A
			else:
				_easter_egg_bonnie_look_camera_backstage()
				current_position = CameraMap.Camera.CAM_5
		CameraMap.Camera.CAM_5, CameraMap.Camera.CAM_1B:
			current_position = CameraMap.Camera.CAM_2A
		CameraMap.Camera.CAM_2A:
			if _fifty_fifty():
				current_position = CameraMap.Camera.CAM_3
			else:
				current_position = CameraMap.Camera.CAM_2B
		CameraMap.Camera.CAM_3:
			if _fifty_fifty():
				current_position = CameraMap.Camera.CAM_2A
			else:
				current_position = CameraMap.Camera.DOOR
		CameraMap.Camera.CAM_2B:
			if _fifty_fifty():
				current_position = CameraMap.Camera.DOOR
			else:
				current_position = CameraMap.Camera.CAM_3
		CameraMap.Camera.DOOR:
			current_position = CameraMap.Camera.CAM_1B
	print("new variant: ", variant)
		

func _easter_egg_bonnie_look_camera_backstage() -> void:
	if randi() % 10 == 0:
		variant = 1
	variant = 0
