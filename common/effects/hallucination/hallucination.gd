extends Node2D

const FLICKER = 0.04
const MAX_HALLICUTAION_SECONDS = 1.8

@onready var frames := $"CanvasLayer/Frames"
@onready var robot_voice := $"Robot Voice"

var current_flicker := 0.0
var current_seconds := 0.0

func _ready() -> void:
	robot_voice.play(10.0)

func _process(delta: float) -> void:
	current_seconds += delta
	if current_seconds >= MAX_HALLICUTAION_SECONDS:
		self.queue_free()
	current_flicker += delta
	if current_flicker >= FLICKER:
		for frame in frames.get_children():
			frame.visible = false
		current_flicker = 0.0
		if randf() < 0.2:
			frames.get_children().pick_random().visible = true
