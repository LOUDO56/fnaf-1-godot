class_name Freddy extends Animatronic

@onready var freddy_laughs := [$"Freddy Laugh 1", $"Freddy Laugh 2", $"Freddy Laugh 3"]

var freddy_max_countdown: float
var freddy_move_countdown := 0.0
var succeed_last_movement := false
var attack_mode := false
var blocked_on_stage := true

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_7],
	CameraMap.Camera.CAM_7: [CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_6: [CameraMap.Camera.CAM_4A],
	CameraMap.Camera.CAM_4A: [CameraMap.Camera.CAM_4B],
	CameraMap.Camera.CAM_4B: [CameraMap.Camera.OFFICE],
}

func _ready() -> void:
	block_moving() # since chica and bonnie are on stage by default, freddy can't move directly
	if ai_level < 10:
		freddy_max_countdown = (1000 - (100 * ai_level)) / 60.0

func _process(delta: float) -> void:
	if ai_level < 10 and succeed_last_movement:
		if freddy_move_countdown < freddy_max_countdown:
			freddy_move_countdown += delta
		elif not is_stalled:
			_move_freddy()
	super._process(delta)
	
func move_ai() -> void:
	if ai_level < 10:
		if succeed_last_movement:
			return
		succeed_last_movement = not is_stalled or attack_mode
	else:
		succeed_last_movement = true
		_move_freddy()
		
func _move_freddy() -> void:
	if is_stalled or in_office():
		return
	reset_freddy_countdown()
	current_position = ROUTES[current_position].pick_random()
	attack_mode = current_position == CameraMap.Camera.CAM_4B
	if attack_mode:
		block_moving()
	_play_laugh()
	succeed_last_movement = false
	
func freddy_enter_office():
	if not succeed_last_movement:
		return
	allow_moving()
	_move_freddy()

func reset_freddy_countdown() -> void:
	freddy_move_countdown = 0

func block_moving() -> void:
	is_stalled = true
	
func allow_moving() -> void:
	if blocked_on_stage:
		return
	is_stalled = false

func _play_laugh():
	freddy_laughs.pick_random().play()
