extends Node2D

@onready var warning_sprite := $"Warning"
@onready var timer := $"Timer"

const FADE_SPEED := 0.8

var current_alpha := 0.0
var fade_out := false

func _ready() -> void:
	warning_sprite.modulate.a = 0.0
	
func _process(delta: float) -> void:
	if not fade_out:
		current_alpha = min(current_alpha + FADE_SPEED * delta, 1.0)
	else:
		current_alpha = max(current_alpha - FADE_SPEED * delta, 0.0)
	warning_sprite.modulate.a = current_alpha
	
	if current_alpha >= 1.0 and not fade_out and timer.is_stopped():
		timer.start()
	elif current_alpha <= 0.0 and fade_out:
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _fade_out() -> void:
	if fade_out or current_alpha < 1.0:
		return
	fade_out = true
	current_alpha = 1.0

func _on_timer_timeout() -> void:
	_fade_out()

func _on_warning_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		return
	_fade_out()
