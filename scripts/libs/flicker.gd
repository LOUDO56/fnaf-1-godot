class_name Flicker extends Node

@export var target: CanvasItem
@export var flicker := 0.5
@export var range_a := 0.0
@export var range_b := 1.0

var current_flicker := 0.0

func _process(delta: float) -> void:
	current_flicker += delta
	if current_flicker >= flicker:
		current_flicker = 0.0
		target.modulate.a = randf_range(range_a, range_b)
