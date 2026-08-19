@abstract class_name Door extends Node2D

const DOOR_SHAPE_ID := 0
const LIGTH_SHAPE_ID := 1
const PRESS_DOOR_DELAY := 0.5
const PRESS_LIGHT_DELAY := 0.2
const FLICKER_LIGHT_MAX := 0.015

@onready var opened := $"Opened"
@onready var closed := $"Closed"
@onready var light_on := $"Light On"
@onready var closed_light_on := $"Closed Light On"

@export var side := "left"
@export var door_animation: AnimatedSprite2D
@export var door_error_sound: AudioStreamPlayer
@export var door_sound: AudioStreamPlayer
@export var light_sound: AudioStreamPlayer
@export var stinger_sound: AudioStreamPlayer
@export var office_stage: OfficeStage

var animatronics: Animatronics
var is_door_closed := false
var is_light_on := false
var can_press_door := true;
var can_press_light := true;
var imminent_death := false
var play_stringer_sound := false
var flicker_light_count := 0.0
var always_on := false

func _ready() -> void:
	Events.power_off.connect(_on_power_off)

func setup(p_animatronics: Animatronics) -> void:
	animatronics = p_animatronics
	setup_animatronics_behavior()

@abstract func setup_animatronics_behavior() -> void
@abstract func change_door_sprite() -> void
@abstract func stop_light_other_door() -> void

func _on_buttons_area_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if imminent_death:
			if can_press_door:
				door_error_sound.play()
				can_press_door = false
				$CooldownPressDoor.start(PRESS_DOOR_DELAY)
			return
		if shape_idx == DOOR_SHAPE_ID and can_press_door:
			toggle_door()
		if shape_idx == LIGTH_SHAPE_ID and can_press_light:
			toggle_light()
			
func _process(delta: float) -> void:
	if not is_light_on:
		return
	flicker_light_count += delta
	if flicker_light_count < FLICKER_LIGHT_MAX:
		return
	flicker_light_count = 0

	if (randf() < 0.2 and not always_on):
		light_sound.volume_db = -100
		office_stage.change_stage(OfficeStage.Stage.NORMAL)
	else:
		light_sound.volume_db = 0
		change_door_sprite()
	always_on = false
		
func _play_stinger() -> void:
	if play_stringer_sound:
		stinger_sound.play()
		play_stringer_sound = false
		
func toggle_door() -> void:
	if is_door_closed:
		open_door()
	else:
		close_door()

func open_door() -> void:
	if not is_door_closed:
		return
	is_door_closed = false
	door_animation.play_backwards("default")
	Events.decrease_power_usage.emit()
	_trigger_door_behavior() 

func close_door() -> void:
	if is_door_closed:
		return
	is_door_closed = true
	door_animation.play("default")
	Events.increase_power_usage.emit()
	_trigger_door_behavior() 
	
func _trigger_door_behavior() -> void:
	door_sound.play()
	can_press_door = false
	$CooldownPressDoor.start(PRESS_DOOR_DELAY)
	_toggle_door_and_light_sprites()

func toggle_light() -> void:
	if is_light_on:
		turn_off_light(true)
	else:
		turn_on_light()


func turn_on_light() -> void:
	if is_light_on:
		return
	flicker_light_count = 0.0
	always_on = true # guarantee to have light when pressing, without it it can start flicker off and looking like there's a delay
	is_light_on = true
	stop_light_other_door()
	light_sound.play()
	Events.increase_power_usage.emit()
	_trigger_light_behavior()
	
func turn_off_light(change_sprite := true) -> void:
	if not is_light_on:
		return
	is_light_on = false
	light_sound.stop()
	if change_sprite:
		office_stage.change_stage(OfficeStage.Stage.NORMAL)
	Events.decrease_power_usage.emit()
	_trigger_light_behavior()
	
func _trigger_light_behavior() -> void:
	can_press_light = false
	$CooldownPressLight.start(PRESS_LIGHT_DELAY)
	_toggle_door_and_light_sprites()

func _get_other_side() -> String:
	if side == "left":
		return "right"
	else:
		return "left"

func _toggle_door_and_light_sprites() -> void:
	if (is_door_closed):
		if (is_light_on):
			_change_state(State.CLOSED_LIGHT_ON)
		else:
			_change_state(State.CLOSED)
	else:
		if (is_light_on):
			_change_state(State.LIGHT_ON)
		else:
			_change_state(State.OPENED)
		
func _change_state(state: State):
	opened.visible = state == State.OPENED
	closed.visible = state == State.CLOSED
	light_on.visible = state == State.LIGHT_ON
	closed_light_on.visible = state == State.CLOSED_LIGHT_ON

func can_enter_office() -> bool:
	return not is_door_closed

func enter_imminent_death() -> void:
	imminent_death = true
	turn_off_light()
	
func _try_attack(animatronic: Animatronic, is_imminent_death := false, instant_jumpscare := false) -> void:
	if not can_enter_office():
		animatronic.step_back()
		return
	animatronic.enter_office()
	if is_imminent_death:
		enter_imminent_death()
	if instant_jumpscare:
		animatronic.play_jumpscare()
		
	
func _on_animatronic_at_door() -> void:
	play_stringer_sound = true
	
func _on_animatronic_left_door() -> void:
	play_stringer_sound = false

func _on_cooldown_press_door_timeout() -> void:
	can_press_door = true

func _on_cooldown_press_light_timeout() -> void:
	can_press_light = true

func _on_power_off() -> void:
	open_door()
	turn_off_light(false)
	set_process(false)
	visible = false

enum State {OPENED, CLOSED, LIGHT_ON, CLOSED_LIGHT_ON}
