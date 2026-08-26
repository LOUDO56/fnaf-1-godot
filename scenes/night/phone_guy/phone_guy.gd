extends Node2D

@onready var voice_night_1 = $"Voice Night 1"
@onready var voice_night_2 = $"Voice Night 2"
@onready var voice_night_3 = $"Voice Night 3"
@onready var voice_night_4 = $"Voice Night 4"
@onready var voice_night_5 = $"Voice Night 5"
@onready var mute_call = $"CanvasLayer/Mute Call"
@onready var hide_mute_timer = $"Hide Mute Timer"
@onready var show_mute_timer = $"Show Mute Timer"

var voice_to_play: AudioStreamPlayer

func _ready() -> void:
	mute_call.visible = false
	match PlayerData.level:
		1: voice_to_play = voice_night_1
		2: voice_to_play = voice_night_2
		3: voice_to_play = voice_night_3
		4: voice_to_play = voice_night_4
		5: voice_to_play = voice_night_5
	if voice_to_play != null and PlayerData.level not in PlayerData.played_phone_guy_voice:
		show_mute_timer.start()
		voice_to_play.play()
		PlayerData.played_phone_guy_voice.append(PlayerData.level)

func _on_mute_call_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		voice_to_play.stop()
		hide_mute_timer.stop()
		mute_call.visible = false

func _on_hide_mute_timer_timeout() -> void:
	mute_call.visible = false

func _on_show_mute_timer_timeout() -> void:
	mute_call.visible = true

func _on_voice_night_5_finished() -> void:
	mute_call.visible = false
