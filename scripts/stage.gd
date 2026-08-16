class_name OfficeStage extends Node2D

@onready var normal_stage := $"Normal"
@onready var power_off_stage := $"Power Off"
@onready var power_off_freddy_stage := $"Power Off Freddy"
@onready var left_light_on_stage := $"Left Light on"
@onready var left_bonnie_light_on_stage := $"Left Bonnie Light On"
@onready var right_light_on_stage := $"Right Light On"
@onready var right_chica_light_on_stage := $"Right Chica Light On"
@onready var black_out := $"Black Out"

var animatronics: Animatronics
var current_stage := Stage.NORMAL

func _ready() -> void:
	Events.power_off.connect(_on_power_off)

func change_stage(stage: Stage) -> void:
	normal_stage.visible = stage == Stage.NORMAL
	power_off_stage.visible = stage == Stage.POWER_OFF
	power_off_freddy_stage.visible = stage == Stage.POWER_OFF_FREDDY
	left_light_on_stage.visible = stage == Stage.LEFT_LIGHT_ON
	left_bonnie_light_on_stage.visible = stage == Stage.LEFT_BONNIE_LIGHT_ON
	right_light_on_stage.visible = stage == Stage.RIGHT_LIGHT_ON
	right_chica_light_on_stage.visible = stage == Stage.RIGHT_CHICA_LIGHT_ON
	black_out.visible = stage == Stage.BLACK_OUT
	current_stage = stage

func _on_power_off():
	change_stage(Stage.POWER_OFF)
	
enum Stage{ NORMAL, POWER_OFF, POWER_OFF_FREDDY, LEFT_LIGHT_ON, LEFT_BONNIE_LIGHT_ON, RIGHT_LIGHT_ON, RIGHT_CHICA_LIGHT_ON, BLACK_OUT }
