class_name SuccessNightAnimation extends Node2D

const FADE_SPEED := 1.0
const DIGIT_SPEED := 21.7

@onready var win_sound := $"Win Sound"
@onready var children_yeah := $"Children Yeah"
@onready var digit_5 := $"CanvasLayer/Zone/5"
@onready var digit_6 := $"CanvasLayer/Zone/6"
@onready var color_rect := $"CanvasLayer/ColorRect"
@onready var black := $"CanvasLayer/Black"

var color_rect_alpha := 0.0
var position_y_to_stop := 0
var fade_out := false
var finished := false
var beat_20_4 := false

func _ready() -> void:
	if PlayerData.night == 5 or PlayerData.night == 6:
		PlayerData.star += 1
	if PlayerData.night == 7 and beat_20_4:
		PlayerData.star += 1
	if PlayerData.night < 6:
		PlayerData.night += 1
	win_sound.play()
	PlayerData.save()
	position_y_to_stop = digit_5.position.y

func check_20_4(animatronics: Animatronics):
	if PlayerData.night != 7:
		return
	beat_20_4 = animatronics.every_animatronic_max_ai()

func _process(delta: float) -> void:
	if finished:
		return

	if not fade_out:
		color_rect_alpha = min(color_rect_alpha + FADE_SPEED * delta, 1.0)
		color_rect.self_modulate.a = color_rect_alpha

	if color_rect_alpha >= 1.0 and digit_6.position.y > position_y_to_stop:
		digit_5.position.y -= DIGIT_SPEED * delta
		digit_6.position.y -= DIGIT_SPEED * delta
		if digit_6.position.y <= position_y_to_stop:
			children_yeah.play()

	if fade_out:
		color_rect_alpha += FADE_SPEED * delta
		black.modulate.a = color_rect_alpha
		if color_rect_alpha >= 1.0:
			finished = true
			_main_screen_or_ending()
			
func _main_screen_or_ending() -> void:
	if PlayerData.night < 5:
		get_tree().change_scene_to_file("res://scenes/main_menu/starting_night.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ending/ending.tscn")

func _on_children_yeah_finished() -> void:
	fade_out = true
	color_rect_alpha = 0.0
