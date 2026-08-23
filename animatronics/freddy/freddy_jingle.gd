class_name FreddyJingle extends Node2D

const TRIGGER_SECONDS_NEXT_STEP := 5.0
const TRIGGER_SECONDS_JUMPSCARE := 2.0
const MAX_SECONDS_STEP_STEP := 20.0
const MAX_BLACK_OUT_FLICKER := 0.3
const FLICKER_FREDDY_FACE := 0.05
const FLICKER_BLACK_OUT := 0.0167

@onready var freddy_jingle_audio := $"Freddy Jingle Audio"
@onready var fan_audio := $"Fan Audio"
@onready var step_sound := $"Step Sound"
@onready var step_sound_default := $"Step Sound/Step Delay"
@onready var animatronics: Animatronics = get_tree().get_first_node_in_group("animatronics")

var current_step_seconds := 0.0
var current_seconds_freddy := 0.0
var current_seconds_transition_blackout := 0.0
var current_flicker_freddy_face := 0.0
var current_step := Step.REACHING_DOOR
var stage: OfficeStage

func _ready() -> void:
	stage = get_parent()
	Events.power_off.connect(_on_power_off)
	set_process(false)

func _process(delta: float) -> void:
	current_seconds_freddy += delta
	current_step_seconds += delta

	if current_step == Step.REACHING_DOOR or current_step == Step.JINGLE:
		if current_seconds_freddy >= TRIGGER_SECONDS_NEXT_STEP or current_step_seconds >= MAX_SECONDS_STEP_STEP:
			if randf() < 0.20:
				_move_to_next_step()
				return
			current_seconds_freddy = 0.0

	if current_step == Step.JINGLE:
		_handle_freddy_flicker(delta)

	if current_step == Step.TRANSITION_BLACK_OUT:
		current_seconds_transition_blackout += delta
		if current_seconds_transition_blackout >= MAX_BLACK_OUT_FLICKER:
			_move_to_next_step()
			return
		elif current_seconds_freddy >= FLICKER_BLACK_OUT:
			current_seconds_freddy = 0.0
			_handle_black_out_flicker()

	if current_step == Step.IN_OFFICE:
		if current_seconds_freddy >= TRIGGER_SECONDS_JUMPSCARE:
			if randf() < 0.20:
				step_sound.stop()
				animatronics.freddy.play_jumpscare_light_out()
				set_process(false)
			current_seconds_freddy = 0.0

func _handle_freddy_flicker(delta: float) -> void:
	current_flicker_freddy_face += delta
	if current_flicker_freddy_face >= FLICKER_FREDDY_FACE:
		current_flicker_freddy_face = 0.0
		if randi_range(1, 4) == 1:
			stage.change_stage(OfficeStage.Stage.POWER_OFF)
		else:
			stage.change_stage(OfficeStage.Stage.POWER_OFF_FREDDY)

func _handle_black_out_flicker() -> void:
	if randf() <= 0.5:
		fan_audio.stop()
		stage.change_stage(OfficeStage.Stage.BLACK_OUT)
	else:
		fan_audio.play()
		stage.change_stage(OfficeStage.Stage.POWER_OFF)

func _move_to_next_step() -> void:
	current_seconds_freddy = 0.0
	current_step_seconds = 0.0
	current_seconds_transition_blackout = 0.0
	current_flicker_freddy_face = 0.0
	match current_step:
		Step.REACHING_DOOR:
			current_step = Step.JINGLE
			freddy_jingle_audio.play()
		Step.JINGLE:
			current_step = Step.TRANSITION_BLACK_OUT
			freddy_jingle_audio.stop()
			stage.change_stage(OfficeStage.Stage.BLACK_OUT)
			fan_audio.stop()
		Step.TRANSITION_BLACK_OUT:
			step_sound.play()
			current_step = Step.IN_OFFICE
			stage.change_stage(OfficeStage.Stage.BLACK_OUT)
			fan_audio.stop()

func _on_power_off() -> void:
	step_sound_default.start()
	set_process(true)

func _on_step_delay_timeout() -> void:
	step_sound.play()

enum Step { REACHING_DOOR, JINGLE, TRANSITION_BLACK_OUT, IN_OFFICE }
