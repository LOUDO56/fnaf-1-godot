class_name Bonnie extends Animatronic

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_5, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_5:  [CameraMap.Camera.CAM_2A, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_2A, CameraMap.Camera.CAM_5],
	CameraMap.Camera.CAM_2A: [CameraMap.Camera.CAM_3, CameraMap.Camera.CAM_2B],
	CameraMap.Camera.CAM_3:  [CameraMap.Camera.CAM_2A, CameraMap.Camera.DOOR],
	CameraMap.Camera.CAM_2B: [CameraMap.Camera.DOOR, CameraMap.Camera.CAM_3],
}

@export var breathing_sounds: Array[AudioStreamPlayer]

func move_ai() -> void:
	current_position = ROUTES[current_position].pick_random()
	if current_position == CameraMap.Camera.CAM_5:
		_easter_egg_bonnie_look_camera_backstage()
		
func _attack_blocked() -> void:
	current_position = CameraMap.Camera.CAM_1B

func play_jumpscare() -> void:
	for breathing_sound in breathing_sounds:
		breathing_sound.stop()
	super.play_jumpscare()

		
func _easter_egg_bonnie_look_camera_backstage() -> void:
	variant = 1 if randi() % 10 == 0 else 0

func on_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	if current_position == CameraMap.Camera.OFFICE:
		play_jumpscare()
