extends Node2D

@export var office: Office
@onready var monitor_animation: MonitorAnimation = $"OfficeCamera/Watching Cameras/CanvasLayer/Monitor"
@onready var office_camera: Camera2D = $"OfficeCamera"

func _ready() -> void:
	office.listen_flip_events(monitor_animation, office_camera)
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)
	
func _on_monitor_opened() -> void:
	office_camera.set_process(false)
	
func _on_monitor_closed() -> void:
	office_camera.set_process(true)
