class_name CameraPoint extends Node2D

@export var camera: CameraMap.Camera
@export var name_texture: Texture

@onready var un_pressed_sprite := $"UnPressed"
@onready var selected_animation := $"SelectedAnimation"
@onready var camera_name := $"../Camera Name"

signal camera_point_clicked(camera: CameraMap.Camera)

func _on_press_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		camera_point_clicked.emit(camera)

func select() -> void:
	un_pressed_sprite.visible = false
	selected_animation.visible = true
	selected_animation.play()
	camera_name.texture = name_texture
	
func unselect() -> void:
	un_pressed_sprite.visible = true
	selected_animation.visible = false
	selected_animation.stop()
