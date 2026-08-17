extends Node2D

const FIRST_HOUR_LENGTH := 90.0
const HOUR_LENGTH := 89.0

@export var game: Game

@onready var digits = $"CanvasLayer/Time/Digits"

@export var animatronics: Animatronics

var current_hour := 0
var elapsed_seconds_between_hour := 0.0

func _ready() -> void:
	Events.power_off.connect(_on_power_off)

func _process(delta: float) -> void:
	elapsed_seconds_between_hour += delta
	if current_hour == 0 and elapsed_seconds_between_hour >= FIRST_HOUR_LENGTH\
	or current_hour >= 1  and elapsed_seconds_between_hour >= HOUR_LENGTH:
		current_hour += 1
		if current_hour >= 2 and current_hour <= 4:
			animatronics.bonnie.ai_level += 1
			if current_hour >= 3:
				animatronics.chica.ai_level += 1
				animatronics.foxy.ai_level += 1
		elapsed_seconds_between_hour = 0.0
		_update_ui_time()
		if current_hour == 6:
			game.success_night()
		
func _update_ui_time() -> void:
	for digit in digits.get_children():
		digit.visible = digit.name != "12" and digit.name == str(current_hour)

func _on_power_off() -> void:
	get_node("CanvasLayer").visible = false

func _on_instant_success_pressed() -> void:
	game.success_night()
