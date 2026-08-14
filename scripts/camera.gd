extends Node2D

@export var office: Node2D

const SLOW_MOVE_SPEED := 200.0
const MED_MOVE_SPEED := 600.0
const FAST_MOVE_SPEED := 800.0

var normal_office_sprite: Sprite2D
var margin_right_office

func _ready() -> void:
	normal_office_sprite = office.get_node("Stage/Normal")
	margin_right_office = (normal_office_sprite.texture.get_width() * normal_office_sprite.scale.x) - get_viewport_rect().size.x

func _process(delta: float) -> void:
	var new_x_position = position.x + _get_movement_speed(_get_mouse_horizontal_ratio()) * delta
	position.x = clamp(new_x_position, 0.0, margin_right_office)

## Get the mouse ratio position on the horizontal screen to check if the mouse is moving left or right on the screen.
func _get_mouse_horizontal_ratio() -> float:
	var mouse_pos_x = get_viewport().get_mouse_position().x
	var viewport_width = get_viewport_rect().size.x
	return clamp(mouse_pos_x / viewport_width, 0.0, 1.0)
	

## Get the movement speed based on the mouse horizontal ratio
func _get_movement_speed(ratio) -> float:
	var speed = 0
	if ratio >= 0.85 or ratio <= 0.15:
		speed = FAST_MOVE_SPEED
	elif ratio >= 0.8 or ratio <= 0.2:
		speed = MED_MOVE_SPEED
	elif ratio >= 0.6 or ratio <= 0.4:
		speed = SLOW_MOVE_SPEED
	if ratio > 0.5:
		return speed
	else:
		return -speed
	
