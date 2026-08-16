extends Node2D

const FADE_SPEED := 1.0
const DIGIT_SPEED := 21.7

@onready var win_sound := $"Win Sound"
@onready var children_yeah := $"Children Yeah"
@onready var digit_5 := $"CanvasLayer/Zone/5"
@onready var digit_6 := $"CanvasLayer/Zone/6"
@onready var color_rect := $"CanvasLayer/ColorRect"

var color_rect_alpha := 0.0
var position_y_to_stop := 0

func _ready() -> void:
	win_sound.play()
	position_y_to_stop = digit_5.position.y

func _process(delta: float) -> void:
	color_rect.self_modulate.a = color_rect_alpha
	color_rect_alpha += FADE_SPEED * delta
	
	if color_rect_alpha >= 1.0 and digit_6.position.y > position_y_to_stop:
		digit_5.position.y -= DIGIT_SPEED * delta
		digit_6.position.y -= DIGIT_SPEED * delta
		if digit_6.position.y <= position_y_to_stop:
			children_yeah.play()
