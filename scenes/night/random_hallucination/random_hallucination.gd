extends Node2D

const HALLUCINATION := preload("res://common/effects/hallucination/hallucination.tscn")

func _on_timer_timeout() -> void:
	if randi_range(1, 1000) == 1:
		get_parent().add_child(HALLUCINATION.instantiate())
