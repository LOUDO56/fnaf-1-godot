extends Node2D

@export var statics: Node2D

const FLICKER_TIMER := 0.0167

var flicker_time := 0.0
var value_b := 0

func _process(delta: float) -> void:
	flicker_time += delta
	if flicker_time >= FLICKER_TIMER:
		flicker_time = 0.0
		statics.modulate.a = randf_range(0.3, 0.45)
