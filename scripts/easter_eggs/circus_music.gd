extends Node2D

@onready var circus_music_sound := $"Circus Music Sound"


func _on_timer_timeout() -> void:
	if randi() % 30 == 0 and not circus_music_sound.playing:
		circus_music_sound.play()
