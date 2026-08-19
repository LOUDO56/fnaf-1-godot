extends Node2D

const FADE_SPEED = 1.0

@onready var white_bars_animation: WhiteBars = $"White Bars Camera"
@onready var fade_and_start_timer := $"Fade And Start Timer"
@onready var nights := $"Nights"

var fade_text := false
var current_alpha := 1.0

func _ready() -> void:
	white_bars_animation.get_node("White Bars Camera Animation").speed_scale = 0.5
	white_bars_animation.play()
	_show_night()
	
func _process(delta: float) -> void:
	if fade_text:
		current_alpha -= FADE_SPEED * delta
		nights.modulate.a = current_alpha
		if current_alpha <= 0.0:
			get_tree().change_scene_to_file("res://scenes/loading/loading_screen.tscn")
	
func _show_night() -> void:
	for night in nights.get_children():
		night.visible = night.name == str(PlayerData.night)

func _on_fade_and_start_timer_timeout() -> void:
	fade_text = true
