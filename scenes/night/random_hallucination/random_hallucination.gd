extends Node2D

const HALLUCINATION := preload("res://common/effects/hallucination/hallucination.tscn")

func _on_timer_timeout() -> void:
	if randi() % 1_000 == 0:
		get_parent().add_child(HALLUCINATION.instantiate())
