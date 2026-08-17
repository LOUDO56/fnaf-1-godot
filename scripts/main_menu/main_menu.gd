extends Node2D

@onready var stars := $"Text/Stars"
@onready var night_6 := $"Text/6th Night"
@onready var custom_night := $"Text/Custom Night"
@onready var night_numbers := $"Text/Continue/Sprite/Current Night/Numbers"
@onready var new_game_screen := preload("res://scenes/main_menu/new_game_screen.tscn").instantiate()

func _ready() -> void:
	stars.get_node("Star 1").visible = PlayerData.star >= 1
	stars.get_node("Star 2").visible = PlayerData.star >= 2
	
	night_6.visible = PlayerData.star >= 1
	custom_night.visible = PlayerData.star >= 2
	
	for number in night_numbers.get_children():
		number.visible = number.name == str(PlayerData.night)
	night_numbers.get_node("5").visible = PlayerData.night >= 5


func _on_new_game_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.night = 1
		get_node("Background").process_mode = Node.PROCESS_MODE_DISABLED
		add_child(new_game_screen)

func _on_continue_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.night = min(PlayerData.night, 5)
		get_tree().change_scene_to_file("res://scenes/main_menu/starting_night.tscn")

func _on_6th_night_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.night = 6
		get_tree().change_scene_to_file("res://scenes/main_menu/starting_night.tscn")
				
func _on_custom_night_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	pass
