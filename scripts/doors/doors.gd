extends Node2D

@onready var left_door_animation = $"Left/Left Door Animation"
@onready var right_door_animation = $"Right/Right Door Animation"
@onready var door_toggle_sound = $"Door Toggle Sound"
@onready var door_light_sound = $"Door Light Sound"

@export var left_door: Door
@export var right_door: Door
@export var office_stage: OfficeStage

var flicker_light_count := 0.0

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
			office_stage.change_stage(OfficeStage.Stage.LEFT_LIGHT_ON)
		if right_door.is_light_on:
			office_stage.change_stage(OfficeStage.Stage.RIGHT_LIGHT_ON)
		

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
	
	if not on:
		return

	if side == "left":
		right_door.turn_off_light()
	else:
		left_door.turn_off_light()
