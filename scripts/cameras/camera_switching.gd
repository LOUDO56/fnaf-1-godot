extends Node2D

@onready var current_camera := Camera.CAM_1A
@onready var statics := $"Statics"

func _on_monitor_monitor_closed() -> void:
	visible = false

func _on_monitor_monitor_opened() -> void:
	visible = true
	_hide_all_camera()
	statics.visible = true
	var current_camera_sprite = _get_sprite_from_camera(current_camera)
	current_camera_sprite.get_parent().visible = true
	current_camera_sprite.visible = true

func _get_sprite_from_camera(camera: Camera) -> Sprite2D:
	if camera == Camera.CAM_1A:
		return $"CAM 1A (Show Stage)/Every Animatronics"
	return $"CAM 1A (Show Stage)/Every Animatronics"
	
func _hide_all_camera():
	for child in get_children():
		if child is Sprite2D:
			child.visible = false

enum Camera {CAM_1A, CAM_1B, CAM_1C, CAM_2A, CAM_20, CAM_3, CAM_4A, CAM_4B, CAM_5, CAM_6, CAM_7}
