class_name FreddyJingle extends Node2D

enum Step { REACHING_DOOR, JINGLE, TRANSITION_BLACK_OUT, IN_OFFICE }

const FLICKER_BLACK_OUT := 0.0167
const NEXT_STEP_CHANCE := 0.20
const JUMPSCARE_CHANCE := 0.20

@onready var freddy_jingle_audio := $"Freddy Jingle Audio"
@onready var fan_audio := $"Fan Audio"
@onready var step_sound := $"Step Sound"
@onready var step_sound_default := $"Step Sound/Step Delay"
@onready var next_step_timer := $"Next Step Timer"
@onready var max_step_timer := $"Max Step Timer"
@onready var freddy_flicker_timer := $"Freddy Flicker Timer"
@onready var black_out_transition_timer := $"Black Out Transition Timer"
@onready var jumpscare_timer := $"Jumpscare Timer"
@onready var animatronics: Animatronics = get_tree().get_first_node_in_group("animatronics")

var current_step := Step.REACHING_DOOR
var current_black_out_flicker := 0.0
var stage: OfficeStage

func _ready() -> void:
	stage = get_parent()
	Events.power_off.connect(_on_power_off)
	set_process(false)

func _process(delta: float) -> void:
	current_black_out_flicker += delta
	if current_black_out_flicker >= FLICKER_BLACK_OUT:
		current_black_out_flicker = 0.0
		_handle_black_out_flicker()

func _handle_black_out_flicker() -> void:
	if randf() <= 0.5:
		fan_audio.stop()
		stage.change_stage(OfficeStage.Stage.BLACK_OUT)
	else:
		fan_audio.play()
		stage.change_stage(OfficeStage.Stage.POWER_OFF)

func _on_power_off() -> void:
	step_sound_default.start()
	_start_step_timers()

func _start_step_timers() -> void:
	next_step_timer.start()
	max_step_timer.start()

func _stop_step_timers() -> void:
	next_step_timer.stop()
	max_step_timer.stop()

func _on_next_step_timer_timeout() -> void:
	if randf() < NEXT_STEP_CHANCE:
		_move_to_next_step()

func _on_max_step_timer_timeout() -> void:
	_move_to_next_step()

func _on_freddy_flicker_timer_timeout() -> void:
	if randi_range(1, 4) == 1:
		stage.change_stage(OfficeStage.Stage.POWER_OFF)
	else:
		stage.change_stage(OfficeStage.Stage.POWER_OFF_FREDDY)

func _on_black_out_transition_timer_timeout() -> void:
	_move_to_next_step()

func _on_jumpscare_timer_timeout() -> void:
	if randf() < JUMPSCARE_CHANCE:
		jumpscare_timer.stop()
		step_sound.stop()
		animatronics.freddy.play_jumpscare_light_out()

func _on_step_delay_timeout() -> void:
	step_sound.play()

func _move_to_next_step() -> void:
	match current_step:
		Step.REACHING_DOOR:
			current_step = Step.JINGLE
			freddy_jingle_audio.play()
			freddy_flicker_timer.start()
			_start_step_timers()
		Step.JINGLE:
			current_step = Step.TRANSITION_BLACK_OUT
			_stop_step_timers()
			freddy_flicker_timer.stop()
			freddy_jingle_audio.stop()
			fan_audio.stop()
			stage.change_stage(OfficeStage.Stage.BLACK_OUT)
			current_black_out_flicker = 0.0
			set_process(true)
			black_out_transition_timer.start()
		Step.TRANSITION_BLACK_OUT:
			current_step = Step.IN_OFFICE
			set_process(false)
			step_sound.play()
			fan_audio.stop()
			stage.change_stage(OfficeStage.Stage.BLACK_OUT)
			jumpscare_timer.start()
