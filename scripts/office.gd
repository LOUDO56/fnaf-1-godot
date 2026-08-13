class_name Office extends Node2D

@onready var fan_audio = $"Fan/Fan Audio"

func listen_flip_events(monitorAnimation: MonitorAnimation) -> void:
	monitorAnimation.monitor_opened.connect(_on_monitor_opened)
	monitorAnimation.monitor_closed.connect(_on_monitor_closed)
	
func _on_monitor_opened():
	visible = false
	fan_audio.volume_db -= 10

func _on_monitor_closed():
	visible = true
	fan_audio.volume_db += 10
