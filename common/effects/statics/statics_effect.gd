extends Node2D

@export var statics: Node2D

const FLICKER_TIMER = 0.027
var flicker_time: float

func _process(delta: float) -> void:
	flicker_time += delta
	if flicker_time >= FLICKER_TIMER:
		var random = randf_range(0.22, 0.35)
		statics.modulate.a = random
		flicker_time = 0.0
