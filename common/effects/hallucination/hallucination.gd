extends Node2D

const FLICKER = 0.0167

@onready var frames := $"CanvasLayer/Frames"
@onready var robot_voice := $"Robot Voice"

var current_flicker := 0.0

func _ready() -> void:
	robot_voice.play(randf_range(0.0, 13.34))

func _process(delta: float) -> void:
	current_flicker += delta
	if current_flicker >= FLICKER:
		for frame in frames.get_children():
			frame.visible = false
		current_flicker = 0.0
		if randi_range(1, 10) == 1:
			frames.get_children().pick_random().visible = true

func _on_hallucination_timer_timeout() -> void:
	self.queue_free()
