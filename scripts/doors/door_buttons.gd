class_name Door extends Node2D

signal toggle_door(side: String, close: bool)
signal toggle_light(side: String, on: bool)

const DOOR_SHAPE_ID := 0
const LIGTH_SHAPE_ID := 1
const PRESS_DOOR_DELAY := 0.5
const PRESS_LIGHT_DELAY := 0.2

@onready var opened := $"Opened"
@onready var closed := $"Closed"
@onready var light_on := $"Light On"
@onready var closed_light_on := $"Closed Light On"

@export var side := "left"

var is_door_closed := false
var is_light_on := false
var can_press_door := true;
var can_press_light := true;

func _on_buttons_area_input_event(_viewport: Node, event: InputEvent,shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if shape_idx == DOOR_SHAPE_ID and can_press_door:
			is_door_closed = !is_door_closed
			toggle_door.emit(side, is_door_closed)
			can_press_door = false
			$CooldownPressDoor.start(PRESS_DOOR_DELAY)
		if shape_idx == LIGTH_SHAPE_ID and can_press_light:
			is_light_on = !is_light_on
			toggle_light.emit(side, is_light_on)
			can_press_light = false
			$CooldownPressLight.start(PRESS_LIGHT_DELAY)
		_toggle_door_and_light()
		
func _toggle_door_and_light():
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

func turn_off_light() -> void:
	if not is_light_on:
		return
	is_light_on = false;
	if is_door_closed:
		_change_state(State.CLOSED)
	else:
		_change_state(State.OPENED)


func _on_cooldown_press_door_timeout() -> void:
	can_press_door = true

func _on_cooldown_press_light_timeout() -> void:
	can_press_light = true


enum State {OPENED, CLOSED, LIGHT_ON, CLOSED_LIGHT_ON}
