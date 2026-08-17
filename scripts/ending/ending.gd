extends Node2D

const FADE_SPEED := 0.4

@onready var timer := $"Timer"
@onready var night_5_ending = $"Sprites/Night 5"
@onready var night_6_ending = $"Sprites/Night 6"
@onready var night_7_ending = $"Sprites/Night 7"

var current_alpha := 0.0
var ending_screen: Sprite2D
var fade_out := false

func _ready() -> void:
	match PlayerData.night:
		5: ending_screen = night_5_ending
		6: ending_screen = night_6_ending
		7: ending_screen = night_7_ending
	ending_screen.visible = true
	ending_screen.modulate.a = 0.0

func _process(delta: float) -> void:
	if not fade_out:
		current_alpha += FADE_SPEED * delta
	else:
		current_alpha -= FADE_SPEED * delta
		if current_alpha <= 0.0:
			get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
		
	current_alpha = clamp(current_alpha, 0.0, 1.0)
	ending_screen.modulate.a = current_alpha

func _on_timer_timeout() -> void:
	fade_out = true


func _on_sprites_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if current_alpha < 1.0:
		return
	fade_out = true
