class_name Office extends Node2D

@onready var fan_audio = $"Fan/Fan Audio"
@onready var doors: Doors = $"Doors"
@onready var office_stage: OfficeStage = $"Stage"
@onready var left_door_buttons: Door = $"Doors/Left/LeftDoorButtons"
@onready var right_door_buttons: Door = $"Doors/Right/RightDoorButtons"

@export var animatronics: Animatronics

var office_camera: Camera2D

func _ready() -> void:
	office_stage.animatronics = animatronics

func listen_flip_events(monitor_animation: MonitorAnimation, office_camera_1: Camera2D) -> void:
	office_camera = office_camera_1
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)
	
func _on_monitor_opened():
	visible = false
	fan_audio.volume_db -= 10
	left_door_buttons.turn_off_light()
	right_door_buttons.turn_off_light()
	doors.stop_light_sound()
	
func hide_doors():
	doors.visible = false

func _on_monitor_closed():
	office_camera.make_current()
	visible = true
	fan_audio.volume_db += 10
