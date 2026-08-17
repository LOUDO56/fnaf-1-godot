extends Node2D

const FADE_SPEED := 1.5

@onready var freddy_level := $"Animatronics/Freddy/Select Level"
@onready var bonnie_level := $"Animatronics/Bonnie/Select Level"
@onready var chica_level := $"Animatronics/Chica/Select Level"
@onready var foxy_level := $"Animatronics/Foxy/Select Level"

var current_alpha := 0.0

func _process(delta: float) -> void:
	current_alpha = min(current_alpha + FADE_SPEED * delta, 1.0)
	self.modulate.a = current_alpha

func _ready() -> void:
	freddy_level.change_level(1)
	bonnie_level.change_level(3)
	chica_level.change_level(3)
	foxy_level.change_level(1)


func _on_ready_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.night = 7
		PlayerData.night_7_ai_level[Freddy] = freddy_level.current_level
		PlayerData.night_7_ai_level[Bonnie] = bonnie_level.current_level
		PlayerData.night_7_ai_level[Chica] = chica_level.current_level
		PlayerData.night_7_ai_level[Foxy] = foxy_level.current_level
		get_tree().change_scene_to_file("res://scenes/main_menu/starting_night.tscn")
