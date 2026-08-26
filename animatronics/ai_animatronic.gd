@abstract class_name Animatronic extends Node2D

signal animatronic_moved(old_position: CameraMap.Camera, new_position: CameraMap.Camera)
signal on_at_door()
signal on_office()
signal on_left_door()
signal on_try_attack()
signal on_finish_jumpscare()

const MAX_AI_LEVEL = 20
const OFFICE_ATTACK_INTERVAL := 1.0
const OFFICE_ATTACK_CHANCE := 0.25

@export var ai_level := 0
@export var movement_timer_seconds := 0.0
@export var step_sound: AudioStreamPlayer
@export var jumpscare_animation: AnimatedSprite2D
@export var jumpscare_audio: AudioStreamPlayer
@export var jumpscare_duration: float

var movement_opportunity := 0.0
var current_position := CameraMap.Camera.CAM_1A
var variant := 0
var is_stalled := false
var monitor_opened := false
var office_attack_countdown := 0.0
var timer_jumpscare: Timer

func _process(delta: float) -> void:
	if current_position == CameraMap.Camera.OFFICE:
		_try_office_attack(delta)
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
		
func _try_to_move() -> void:
	var old_position = current_position
	var picked_nb = randi_range(1, MAX_AI_LEVEL)
	var cannot_move = ai_level < picked_nb or current_position == CameraMap.Camera.OFFICE
	
	if cannot_move:
		return
	
	if _can_try_attack():
		on_try_attack.emit()
		return
		
	_define_random_variant()
	move_ai()
	_play_step_sound()
	animatronic_moved.emit(old_position, current_position)
	
	if at_door():
		on_at_door.emit()
	if old_position == CameraMap.Camera.DOOR and not at_door():
		on_left_door.emit()

func _can_try_attack():
	return current_position == CameraMap.Camera.DOOR

func _try_office_attack(delta: float) -> void:
	if monitor_opened or jumpscare_animation.visible:
		return
	office_attack_countdown += delta
	if office_attack_countdown < OFFICE_ATTACK_INTERVAL:
		return
	office_attack_countdown = 0.0
	if randf() < OFFICE_ATTACK_CHANCE:
		play_jumpscare()

func play_jumpscare() -> void:
	if not in_office():
		return
	jumpscare_audio.play()
	jumpscare_animation.visible = true
	jumpscare_animation.play()
	Events.jumpscare_started.emit(jumpscare_duration, self)
	Events.disable_gameplay.emit()


func cancel_jumpscare() -> void:
	office_attack_countdown = 0.0
	current_position = CameraMap.Camera.CAM_1A
	jumpscare_audio.stop()
	jumpscare_animation.visible = false
	jumpscare_animation.stop()
	
func on_jumpscare_timeout():
	on_finish_jumpscare.emit()

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
		CameraMap.Camera.OFFICE:
			return -5.0
	return -8.0
	
func step_back():
	_play_step_sound()
	_attack_blocked()

func enter_office():
	current_position = CameraMap.Camera.OFFICE
	on_office.emit()
	_play_step_sound()

@abstract func move_ai() -> void
@abstract func _attack_blocked() -> void
