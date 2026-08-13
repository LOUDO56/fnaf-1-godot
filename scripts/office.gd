class_name Office extends Node2D

func listen_flip_events(monitorAnimation: MonitorAnimation) -> void:
	monitorAnimation.monitor_opened.connect(_on_monitor_opened)
	monitorAnimation.monitor_closed.connect(_on_monitor_closed)
	
func _on_monitor_opened():
	visible = false

func _on_monitor_closed():
	visible = true
