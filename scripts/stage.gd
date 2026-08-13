class_name OfficeStage extends Node2D

@onready var normal_stage := $"Normal"
@onready var left_light_on_stage := $"Left Light on"
@onready var right_light_on_stage := $"Right Light On"

func change_stage(stage: Stage) -> void:
	normal_stage.visible = stage == Stage.NORMAL
	left_light_on_stage.visible = stage == Stage.LEFT_LIGHT_ON
	right_light_on_stage.visible = stage == Stage.RIGHT_LIGHT_ON

func _on_door_buttons_toggle_light(side: String, on: bool) -> void:
	if on:
		if side == "left":
			change_stage(OfficeStage.Stage.LEFT_LIGHT_ON)
		else:
			change_stage(OfficeStage.Stage.RIGHT_LIGHT_ON)
	else:
		change_stage(OfficeStage.Stage.NORMAL)

enum Stage{ NORMAL, LEFT_LIGHT_ON, RIGHT_LIGHT_ON }
