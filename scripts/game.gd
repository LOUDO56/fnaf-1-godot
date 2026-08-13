extends Node2D

@export var office: Office
@onready var monitorAnimation: MonitorAnimation = $"Camera2D/Watching Cameras/Monitor"

func _ready() -> void:
	office.listen_flip_events(monitorAnimation)
