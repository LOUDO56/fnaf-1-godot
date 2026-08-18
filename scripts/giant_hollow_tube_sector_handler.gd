class_name GiantHollowTubeSectorHandler extends Node2D

const BONNIE_THREAT_LOCATION = [
	CameraMap.Camera.CAM_2A, 
	CameraMap.Camera.CAM_2B, 
	CameraMap.Camera.CAM_3,
	CameraMap.Camera.DOOR
]
const CHICA_THREAT_LOCATION = [
	CameraMap.Camera.CAM_4A, 
	CameraMap.Camera.CAM_4B,
	CameraMap.Camera.DOOR
]
const FOXY_STAGE_THREAT = 3

@export var animatronics: Animatronics

@onready var ambiance_sound := $"Ambiance Sound"

func _ready() -> void:
	_handle_ambiance_volume()
	animatronics.bonnie.animatronic_moved.connect(_on_bonnie_move)
	animatronics.chica.animatronic_moved.connect(_on_chica_move)
	animatronics.freddy.on_office.connect(_on_freddy_enter_office)
	animatronics.foxy.step_attack_changed.connect(_on_foxy_step_attack_change)
	
func _handle_ambiance_volume() -> void:
	var threat = 0
	if animatronics.bonnie.current_position in BONNIE_THREAT_LOCATION:
		threat += 1
	if animatronics.chica.current_position in CHICA_THREAT_LOCATION:
		threat += 1
	if animatronics.foxy.step_attack >= 2:
		threat += 1
	if animatronics.freddy.in_office():
		threat = 4
		
	match threat:
		0: ambiance_sound.volume_db = -999.0
		1: ambiance_sound.volume_db = 5.5
		2: ambiance_sound.volume_db = -1
		3: ambiance_sound.volume_db = 2.5
		4: ambiance_sound.volume_db = 5

func _on_freddy_enter_office() -> void:
	_handle_ambiance_volume()

func _on_foxy_step_attack_change(_new_step_attack: int) -> void:
	_handle_ambiance_volume()

func _on_bonnie_move(_old_position: CameraMap.Camera, _new_position: CameraMap.Camera) ->  void:
	_handle_ambiance_volume()

func _on_chica_move(_old_position: CameraMap.Camera, _new_position: CameraMap.Camera) ->  void:
	_handle_ambiance_volume()
