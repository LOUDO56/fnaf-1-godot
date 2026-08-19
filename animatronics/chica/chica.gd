class_name Chica extends Animatronic

@onready var kitchen_mess_audios := [$"Kitchen Mess Audio 1", $"Kitchen Mess Audio 2", $"Kitchen Mess Audio 3", $"Kitchen Mess Audio 4"]
@onready var kitchen_audio_interval := $"Kitchen Audio Interval"

@export var breathing_sounds: Array[AudioStreamPlayer]

var current_kitchen_mess_audio: AudioStreamPlayer

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_7, CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_7:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_6:  [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_7],
	CameraMap.Camera.CAM_4A: [CameraMap.Camera.CAM_4B, CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_4B: [CameraMap.Camera.CAM_4A, CameraMap.Camera.DOOR],
}

func _ready() -> void:
	decrease_kitchen_sound()
	Events.disable_gameplay.connect(_on_disabled_gameplay)

func move_ai() -> void:
	current_position = ROUTES[current_position].pick_random()
	if current_position == CameraMap.Camera.CAM_6:
		kitchen_audio_interval.start()
		_play_random_kitchen_sound()
	else:
		kitchen_audio_interval.stop()
		if current_kitchen_mess_audio != null:
			current_kitchen_mess_audio.stop()

func play_jumpscare() -> void:
	for breathing_sound in breathing_sounds:
		breathing_sound.stop()
	super.play_jumpscare()


func _attack_blocked() -> void:
	current_position = [CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_1B].pick_random()

func increase_kitchen_sound():
	for kitchen_mess_audio in kitchen_mess_audios:
		kitchen_mess_audio.volume_db = -3.0
	
func decrease_kitchen_sound():
	for kitchen_mess_audio in kitchen_mess_audios:
		kitchen_mess_audio.volume_db = -20.0

func _play_random_kitchen_sound():
	if current_kitchen_mess_audio == null or !current_kitchen_mess_audio.playing:
		current_kitchen_mess_audio = kitchen_mess_audios.pick_random() 
		current_kitchen_mess_audio.play()

func _on_kitchen_audio_interval_timeout() -> void:
	_play_random_kitchen_sound()

func _on_disabled_gameplay() -> void:
	kitchen_audio_interval.stop()
	
func on_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	decrease_kitchen_sound()
	if current_position == CameraMap.Camera.OFFICE:
		play_jumpscare()
	
func on_camera_changed(camera: CameraMap.Camera) -> void:
	if camera == CameraMap.Camera.CAM_6:
		increase_kitchen_sound()
	else:
		decrease_kitchen_sound()
