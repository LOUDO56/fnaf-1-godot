class_name CameraPoint extends Node2D

@export var id: CameraMap.Camera
@export var name_texture: Texture

@onready var un_pressed_sprite := $"UnPressed"
@onready var pressed_sprite := $"Pressed"
@onready var camera_name := $"../Camera Name"

signal on_camera_point_clicked(id: CameraMap.Camera)


func _on_press_zone_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		on_camera_point_clicked.emit(id)

func select() -> void:
	un_pressed_sprite.visible = false
	pressed_sprite.visible = true
	camera_name.texture = name_texture
	
func unselect() -> void:
	un_pressed_sprite.visible = true
	pressed_sprite.visible = false
