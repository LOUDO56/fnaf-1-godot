extends Node2D

@onready var static_sound := $"Static Sound"

func _ready() -> void:
	static_sound.play()
