class_name SelectLevel extends Node2D

@onready var digits_1 = $"Numbers/Digits 1"
@onready var digits_2 = $"Numbers/Digits 2"

@export var progress_level = 20

func _ready() -> void:
	_update_number()
	
func change_level(new_level: int) -> void:
	progress_level = new_level
	_update_number()

func _update_number() -> void:
	var first_number = int(progress_level / 10.0)
	var second_number = int(progress_level % 10)
	
	if progress_level >= 10:
		for digit in digits_1.get_children():
			digit.visible = digit.name == str(first_number)
	else:
		for digit in digits_1.get_children():
			digit.visible = false
			
	for digit in digits_2.get_children():
		digit.visible = digit.name == str(second_number)


func _on_right_arrow_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		progress_level = min(progress_level + 1, 20)
		_update_number()


func _on_left_arrow_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		progress_level = max(0, progress_level - 1)
		_update_number()
