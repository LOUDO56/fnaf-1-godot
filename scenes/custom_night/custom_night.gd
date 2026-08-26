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
		if freddy_level.progress_level == 1 and bonnie_level.progress_level == 9\
		and chica_level.progress_level == 8 and foxy_level.progress_level == 7:
			get_tree().change_scene_to_file("res://scenes/creepy_end/creepy_end.tscn")
			return
		
		PlayerData.level = 7
		PlayerData.level_7_ai_level[Freddy] = freddy_level.progress_level
		PlayerData.level_7_ai_level[Bonnie] = bonnie_level.progress_level
		PlayerData.level_7_ai_level[Chica] = chica_level.progress_level
		PlayerData.level_7_ai_level[Foxy] = foxy_level.progress_level
		PlayerData.beating_20_4 = _20_4()
		get_tree().change_scene_to_file("res://scenes/starting_night/starting_night.tscn")

func _20_4() -> bool:
	return freddy_level.progress_level == 20 and bonnie_level.progress_level == 20 \
	and chica_level.progress_level == 20 and foxy_level.progress_level == 20
