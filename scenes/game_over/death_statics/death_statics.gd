extends Node2D

@onready var static_sound := $"Static Sound"
@onready var game_over_timer := $"Game Over Timer"
@onready var white_bars := $"White Bars Camera"
@onready var statics := $"Statics/StaticAnimation"
@onready var game_over := preload("res://scenes/game_over/game_over.tscn").instantiate()

func _ready() -> void:
	statics.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	static_sound.play()
	game_over_timer.start()
	white_bars.white_bars_camera_animation.visible = true
	white_bars.white_bars_camera_animation.play()


func _on_game_over_timer_timeout() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	add_child(game_over)
	game_over.process_mode = Node.PROCESS_MODE_ALWAYS
