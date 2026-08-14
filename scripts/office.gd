class_name Office extends Node2D

@onready var fan_audio = $"Fan/Fan Audio"
@onready var left_door_buttons: Door = $"Doors/Left/LeftDoorButtons"
@onready var right_door_buttons: Door = $"Doors/Right/RightDoorButtons"

var office_camera: Camera2D

func listen_flip_events(monitor_animation: MonitorAnimation, office_camera: Camera2D) -> void:
	self.office_camera = office_camera
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)
	
func _on_monitor_opened():
	visible = false
	fan_audio.volume_db -= 10
	left_door_buttons.turn_off_light()
	right_door_buttons.turn_off_light()

func _on_monitor_closed():
	office_camera.make_current()
	visible = true
	fan_audio.volume_db += 10
