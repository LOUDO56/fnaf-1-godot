class_name Chica extends Animatronic

@onready var kitchen_mess_audios := [$"Kitchen Mess Audio 1", $"Kitchen Mess Audio 2", $"Kitchen Mess Audio 3", $"Kitchen Mess Audio 4"]
@onready var kitchen_audio_interval := $"Kitchen Audio Interval"

var current_kitchen_mess_audio: AudioStreamPlayer

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_7, CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_7:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_6:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_7],
	CameraMap.Camera.CAM_4A: [CameraMap.Camera.CAM_4B, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_4B: [CameraMap.Camera.CAM_4A, CameraMap.Camera.DOOR],
	CameraMap.Camera.DOOR:   [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_1B],
}
func move_ai() -> void:
	current_position = ROUTES[current_position].pick_random()
	if current_position == CameraMap.Camera.CAM_6:
		kitchen_audio_interval.start()
		_play_random_kitchen_sound()
	else:
		kitchen_audio_interval.stop()
		if current_kitchen_mess_audio != null:
			current_kitchen_mess_audio.stop()
	
func _play_step_sound():
	if current_position == CameraMap.Camera.CAM_1A:
		step_sound.volume_db = -18.0
	else:
		step_sound.volume_db = -10.0
	step_sound.play()
	
func increase_kitchen_sound():
	if current_kitchen_mess_audio == null or !current_kitchen_mess_audio.playing:
		return
	current_kitchen_mess_audio.volume_db = -3.0
	
func decrease_kitchen_sound():
	if current_kitchen_mess_audio == null or !current_kitchen_mess_audio.playing:
			return
	current_kitchen_mess_audio.volume_db = -17.0

func _play_random_kitchen_sound():
	if current_kitchen_mess_audio == null or !current_kitchen_mess_audio.playing:
		current_kitchen_mess_audio = kitchen_mess_audios.pick_random() 
		current_kitchen_mess_audio.play()

func _on_kitchen_audio_interval_timeout() -> void:
	_play_random_kitchen_sound()
