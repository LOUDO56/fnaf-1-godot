extends Node2D

@onready var stars := $"Text/Stars"
@onready var night_6 := $"Text/6th Night"
@onready var custom_night := $"Text/Custom Night"
@onready var night_numbers := $"Text/Continue/Sprite/Current Night/Numbers"
@onready var new_game_screen := preload("res://scenes/new_game/new_game_screen.tscn").instantiate()
@onready var custom_night_screen := preload("res://scenes/custom_night/custom_night.tscn").instantiate()

func _ready() -> void:
	if randi() % 1_000 == 0:
		get_tree().change_scene_to_file("res://scenes/eyesless_bonnie/eyesless_bonnie.tscn")
		return
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), false)
	
	stars.get_node("Star 1").visible = PlayerData.beat_game
	stars.get_node("Star 2").visible = PlayerData.beat6
	stars.get_node("Star 3").visible = PlayerData.beat7
	
	night_6.visible = PlayerData.beat_game
	custom_night.visible = PlayerData.beat6
	
	for number in night_numbers.get_children():
		number.visible = number.name == str(PlayerData.progress_level)


func _on_new_game_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.level = 1
		PlayerData.progress_level = 1
		PlayerData.save()
		get_node("Background").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("Text").process_mode = Node.PROCESS_MODE_DISABLED
		add_child(new_game_screen)

func _on_continue_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.level = min(PlayerData.progress_level, 5)
		get_tree().change_scene_to_file("res://scenes/starting_night/starting_night.tscn")

func _on_6th_night_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.level = 6
		get_tree().change_scene_to_file("res://scenes/starting_night/starting_night.tscn")
				
func _on_custom_night_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		PlayerData.level = 7
		get_node("Background").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("Text").process_mode = Node.PROCESS_MODE_DISABLED
		add_child(custom_night_screen)
