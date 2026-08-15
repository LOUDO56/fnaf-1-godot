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
var is_stalled := false

func _process(delta: float) -> void:
	if current_position == CameraMap.Camera.OFFICE:
		return
	movement_opportunity += delta
	if movement_opportunity >= movement_timer_seconds:
		movement_opportunity = 0
		_try_to_move()
		
func at_door() -> bool:
	return current_position == CameraMap.Camera.DOOR

func in_office() -> bool:
	return current_position == CameraMap.Camera.OFFICE

func on_stage() -> bool:
	return current_position == CameraMap.Camera.CAM_1A
	
func block_moving() -> void:
	is_stalled = true
	
func allow_moving() -> void:
	is_stalled = false
		
func _fifty_fifty() -> bool:
	return randi() % 2 == 0
		
func _try_to_move() -> void:
	var old_position = current_position
	var picked_nb = randi_range(1, MAX_AI_LEVEL)
	var cannot_move = ai_level < picked_nb or is_stalled
	
	if cannot_move:
		return
		
	_define_random_variant()
	move_ai()
	_play_step_sound()
	on_animatronic_moved.emit(old_position, current_position)
	
	if at_door():
		on_at_door.emit()
	if old_position == CameraMap.Camera.DOOR and not at_door():
		on_left_door.emit()

## Used for camera spot where the animatronic has position variation
func _define_random_variant(max_variant := 1) -> void:
	variant = randi_range(0, max_variant)
	
func _play_step_sound() -> void:
	if step_sound == null:
		return
	step_sound.volume_db = _get_step_sound_db_distance();
	step_sound.play()
	
func _get_step_sound_db_distance() -> float:
	match current_position:
		CameraMap.Camera.CAM_1B, CameraMap.Camera.CAM_5, CameraMap.Camera.CAM_7:
			return -18.0
		CameraMap.Camera.CAM_3, CameraMap.Camera.CAM_1C, CameraMap.Camera.CAM_2A, CameraMap.Camera.CAM_4A, CameraMap.Camera.CAM_6:
			return -14.0
		CameraMap.Camera.CAM_2B, CameraMap.Camera.CAM_4B:
			return -10.0
	return -5.0
	
@abstract func move_ai() -> void
	
