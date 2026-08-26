class_name SuccessNightAnimation extends Node2D

const FADE_SPEED := 1.0
const DIGIT_SPEED := 21.7

@onready var animatronics: Animatronics = get_tree().get_first_node_in_group("animatronics")
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
var play_ending := false

func _ready() -> void:
	if PlayerData.level == 5:
		play_ending = true
		PlayerData.beat_game = true
	if PlayerData.level == 6:
		play_ending = true
		PlayerData.beat6 = true
	if  PlayerData.level == 7:
		play_ending = true
		if beat_20_4():
			PlayerData.beat7 = true
	PlayerData.beating_20_4 = false
	
	PlayerData.progress_level += 1
	if PlayerData.progress_level < 6:
		PlayerData.level = PlayerData.progress_level
	PlayerData.progress_level = min(5, PlayerData.progress_level)
	
	win_sound.play()
	PlayerData.save()
	position_y_to_stop = digit_5.position.y

func beat_20_4():
	if PlayerData.level != 7:
		return
	return animatronics.every_animatronic_max_ai() and PlayerData.beating_20_4

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
	if play_ending:
		get_tree().change_scene_to_file("res://scenes/ending/ending.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/starting_night/starting_night.tscn")

func _on_children_yeah_finished() -> void:
	fade_out = true
	color_rect_alpha = 0.0
