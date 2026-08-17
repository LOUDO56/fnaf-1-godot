extends Node2D

const FADE_SPEED := 0.4

@onready var help_wanted := $"Help Wanted"
@onready var timer := $"Timer" 
@onready var color_rect := $"ColorRect" 

var current_alpha := 0.0
var fade_out := false
var finished := false

func _process(delta: float) -> void:
	if finished:
		return

	if fade_out:
		current_alpha -= FADE_SPEED * delta
	else:
		current_alpha += FADE_SPEED * delta

	current_alpha = clamp(current_alpha, 0.0, 1.0)
	help_wanted.modulate.a = current_alpha

	if fade_out and current_alpha <= 0.0:
		finished = true
		get_tree().change_scene_to_file("res://scenes/main_menu/starting_night.tscn")

func _fade_out() -> void:
	if current_alpha < 1.0:
		return
	fade_out = true
	color_rect.visible = true
	
func _on_timer_timeout() -> void:
	_fade_out()
	
func _on_help_wanted_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	_fade_out()
	
