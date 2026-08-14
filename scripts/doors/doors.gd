class_name Doors extends Node2D

@onready var left_door_animation = $"Left/Left Door Animation"
@onready var right_door_animation = $"Right/Right Door Animation"
@onready var door_toggle_sound = $"Door Toggle Sound"
@onready var door_light_sound = $"Door Light Sound"
@onready var stringer_sound = $"Stinger Sound"

@export var left_door: Door
@export var right_door: Door
@export var office_stage: OfficeStage

var animatronics: Animatronics

var flicker_light_count := 0.0
var play_stringer_sound_left := false
var play_stringer_sound_right := false

func setup_animatronics_behavior(p_animatronics: Animatronics) -> void:
	animatronics = p_animatronics
	animatronics.bonnie.on_at_door.connect(_on_bonnie_at_door)
	animatronics.bonnie.on_left_door.connect(_on_bonnie_left_door)

func _process(delta: float) -> void:
	flicker_light_count += delta
	if flicker_light_count < 0.027:
		return
	flicker_light_count = 0

	if (randi() % 10 > 7):
		door_light_sound.volume_db = -100
		office_stage.change_stage(OfficeStage.Stage.NORMAL)
	else:
		door_light_sound.volume_db = 0
		if left_door.is_light_on:
			if animatronics.bonnie.at_door():
				_play_stinger_sound("left")
				office_stage.change_stage(OfficeStage.Stage.LEFT_BONNIE_LIGHT_ON)
			else:
				office_stage.change_stage(OfficeStage.Stage.LEFT_LIGHT_ON)
		if right_door.is_light_on:
			office_stage.change_stage(OfficeStage.Stage.RIGHT_LIGHT_ON)
		
func stop_light_sound():
	door_light_sound.stop()

func _on_door_buttons_toggle_door(side: String, close: bool) -> void:
	var door_animation: AnimatedSprite2D
	if side == "left":
		door_animation = left_door_animation
	if side == "right":
		door_animation = right_door_animation
		
	if close:
		door_animation.play("default")
	else:
		door_animation.play_backwards("default")
		
	door_toggle_sound.play()


func _on_door_buttons_toggle_light(side: String, on: bool) -> void:
	if on:
		door_light_sound.play()
	else:
		door_light_sound.stop()

	_play_stinger_sound(side)

	if not on:
		return

	if side == "left":
		right_door.turn_off_light()
	else:
		left_door.turn_off_light()

func _play_stinger_sound(side):
	if side == "left" and play_stringer_sound_left:
		stringer_sound.play()
		play_stringer_sound_left = false
	if side == "right" and play_stringer_sound_right:
		stringer_sound.play()
		play_stringer_sound_right = false
		
func _on_bonnie_at_door():
	play_stringer_sound_left = true
	
func _on_bonnie_left_door():
	play_stringer_sound_left = false
