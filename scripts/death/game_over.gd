extends Node2D

const FADE_SPEED := 1.0

@onready var group := $"Group"
@onready var timer := $"Timer"

func _ready() -> void:
	group.modulate.a = 0.0

func _process(delta: float) -> void:
	if group.modulate.a < 1.0:
		group.modulate.a += FADE_SPEED * delta


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
