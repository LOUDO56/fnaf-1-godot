@abstract class_name Animatronic extends Node2D

signal on_animatronic_moved(old_position, new_position)
signal on_at_door()
signal on_left_door()
signal on_inside_office()

const MAX_AI_LEVEL = 20

@export var ai_level := 0
@export var movement_timer_seconds := 0.0
@export var step_sound: AudioStreamPlayer

var movement_opportunity := 0.0
var current_position := CameraMap.Camera.CAM_1A
var variant := 0

func _process(delta: float) -> void:
	movement_opportunity += delta
	if movement_opportunity >= movement_timer_seconds:
		movement_opportunity = 0
		_try_to_move()
		
func at_door() -> bool:
	return current_position == CameraMap.Camera.DOOR
		
func _fifty_fifty() -> int:
	return randi() % 2 == 1
		
func _try_to_move() -> void:
	_define_random_variant()
	var old_position = current_position
	var can_move = ai_level >= randi() % 20
	if can_move:
		_play_step_sound()
		move_ai()
	on_animatronic_moved.emit(old_position, current_position)
	
	if at_door():
		on_at_door.emit()
	if old_position == CameraMap.Camera.DOOR and not at_door():
		on_left_door.emit()

func _define_random_variant(max_variant := 1) -> void:
	variant = randi() % max_variant + 1
	
func _play_step_sound():
	if step_sound == null:
		return
	step_sound.play()
		
@abstract func move_ai() -> void
	
