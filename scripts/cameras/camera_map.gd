class_name CameraMap extends Node2D

signal camera_changed(id: Camera)

@onready var click_sound = $"Click Sound"
@onready var white_bars: WhiteBars = $"CanvasLayer/White Bars Camera"

var selected_camera_id := Camera.CAM_1A

func _on_camera_point_clicked(id: Camera) -> void:
	select_camera(id)

func select_camera(id: Camera) -> void:
	for child in get_node("Map").get_children():
		if child is CameraPoint:
			if child.id == id:
				child.select()
			else:
				child.unselect()
	selected_camera_id = id
	white_bars.play()
	camera_changed.emit(id)

enum Camera {CAM_1A, CAM_1B, CAM_1C, CAM_2A, CAM_2B, CAM_3, CAM_4A, CAM_4B, CAM_5, CAM_6, CAM_7, DOOR}
