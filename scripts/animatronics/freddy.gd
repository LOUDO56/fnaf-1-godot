class_name Freddy extends Animatronic

@export var jumpscare_light_out_animation: AnimatedSprite2D

@onready var freddy_laughs := [$"Freddy Laugh 1", $"Freddy Laugh 2", $"Freddy Laugh 3"]
@onready var freddy_jingle := $"Freddy Jingle"
@onready var freddy_jumpscare_timer := $"Freddy Jumpscare Timer"
@onready var freddy_step := $"Freddy Step"

var freddy_max_countdown: float
var freddy_move_countdown := 0.0
var succeed_last_movement := false
var attack_mode := false
var bonnie_left_stage := false
var chica_left_stage := false

const ROUTES := {
	CameraMap.Camera.CAM_1A: [CameraMap.Camera.CAM_1B],
	CameraMap.Camera.CAM_1B: [CameraMap.Camera.CAM_7],
	CameraMap.Camera.CAM_7: [CameraMap.Camera.CAM_6],
	CameraMap.Camera.CAM_6: [CameraMap.Camera.CAM_4A],
	CameraMap.Camera.CAM_4A: [CameraMap.Camera.CAM_4B],
	CameraMap.Camera.CAM_4B: [CameraMap.Camera.CAM_4A],
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

func _can_try_attack():
	return attack_mode and not is_stalled and randi() % 2 == 0 # to allow freddy to either try attack or return to 4A		

func get_character() -> Animatronics.Character:
	return Animatronics.Character.FREDDY

func step_back():
	if is_stalled:
		return
	_play_laugh()
	_attack_blocked()

func _attack_blocked() -> void:
	current_position = CameraMap.Camera.CAM_4A
	succeed_last_movement = false
	attack_mode = false
	is_stalled = true

func _move_freddy() -> void:
	if is_stalled:
		return
	reset_freddy_countdown()
	if current_position != CameraMap.Camera.OFFICE:
		current_position = ROUTES[current_position].pick_random()
	attack_mode = current_position == CameraMap.Camera.CAM_4B
	if attack_mode:
		block_moving()
	_play_laugh()
	succeed_last_movement = false
	if current_position == CameraMap.Camera.CAM_6:
		decrease_jingle()
		freddy_jingle.play()
	else:
		freddy_jingle.stop()
	if current_position == CameraMap.Camera.OFFICE:
		freddy_jumpscare_timer.start()

func play_jumpscare_light_out() -> void:
	jumpscare_audio.play()
	jumpscare_light_out_animation.visible = true
	jumpscare_light_out_animation.play()
	Events.jumpscare_started.emit(0.7, self)

func power_off_mode() -> bool:
	return jumpscare_light_out_animation.visible

func increase_jingle() -> void:
	freddy_jingle.volume_db = -5.0
	
func decrease_jingle() -> void:
	freddy_jingle.volume_db = -26.0
	
func enter_office() -> void:
	if not succeed_last_movement:
		return
	current_position = CameraMap.Camera.OFFICE
	allow_moving()
	_move_freddy()
	block_moving()

func reset_freddy_countdown() -> void:
	freddy_move_countdown = 0
	
func allow_moving() -> void:
	if not chica_left_stage or not bonnie_left_stage:
		return
	super.allow_moving()

func _play_laugh():
	for laugh: AudioStreamPlayer in freddy_laughs:
		laugh.volume_db = _get_step_sound_db_distance()
		laugh.stop()
	freddy_laughs.pick_random().play()
	freddy_step.volume_db = _get_step_sound_db_distance() + 5.0
	freddy_step.play()
	
func _on_move_freddy_pressed() -> void:
	is_stalled = false
	bonnie_left_stage = true
	chica_left_stage = true
	_move_freddy()

func _on_freddy_jumpscare_timer_timeout() -> void:
	if randf() < 0.25 and not is_stalled:
		play_jumpscare()
		freddy_jumpscare_timer.stop()
		
func on_monitor_closed(last_camera_viewed: CameraMap.Camera) -> void:
	if not attack_mode or last_camera_viewed != CameraMap.Camera.CAM_4B:
		allow_moving()
	decrease_jingle()
	
func on_monitor_opened() -> void:
	block_moving()

func on_camera_changed(camera: CameraMap.Camera) -> void:
	if camera == current_position:
		reset_freddy_countdown()
	if attack_mode and camera != CameraMap.Camera.CAM_4B and succeed_last_movement:
		on_try_attack.emit()
	if camera == CameraMap.Camera.CAM_6:
		increase_jingle()
	else:
		decrease_jingle()

func on_bonnie_move(old_position: CameraMap.Camera, _new_position: CameraMap.Camera):
	if old_position == CameraMap.Camera.CAM_1A:
		bonnie_left_stage = true
	
func on_chica_move(old_position: CameraMap.Camera, _new_position: CameraMap.Camera):
	if old_position == CameraMap.Camera.CAM_1A:
		chica_left_stage = true
