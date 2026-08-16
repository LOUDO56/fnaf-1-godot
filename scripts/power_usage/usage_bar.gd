class_name PowerUsage extends Node2D

@onready var bars = $"Bars"

func _ready() -> void:
	Events.increase_power_usage.connect(_on_power_increase)
	Events.decrease_power_usage.connect(_on_power_decrease)

var consumption_level := 1

func _on_power_increase() -> void:
	if consumption_level >= 5:
		return
	consumption_level += 1
	_update_bar()
	
func _on_power_decrease() -> void:
	consumption_level -= 1
	_update_bar()

func _update_bar() -> void:
	for bar in bars.get_children():
		bar.visible = str(consumption_level) == bar.name
