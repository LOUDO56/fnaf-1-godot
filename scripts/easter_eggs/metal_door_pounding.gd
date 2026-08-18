extends Node2D

@onready var metal_door_pounding_sound := $"Metal Door Pounding Sound"

func _on_timer_timeout() -> void:
	if randi() % 2 == 0:
		metal_door_pounding_sound.play()
