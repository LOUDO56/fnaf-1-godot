class_name Hover extends Area2D

signal hovered(y_position: float)

@onready var collision_shape: CollisionShape2D = $"CollisionShape2D"

func _on_mouse_entered() -> void:
	hovered.emit(position.y)
