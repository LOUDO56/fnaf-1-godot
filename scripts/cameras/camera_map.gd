class_name CameraMap extends Node2D

signal camera_changed(camera: Camera)

@onready var click_sound = $"Click Sound"
@onready var white_bars: WhiteBars = $"CanvasLayer/White Bars Camera"

var selected_camera := Camera.CAM_1A

func _on_camera_point_clicked(camera: Camera) -> void:
	select_camera(camera)

func select_camera(camera: Camera) -> void:
	for child in get_node("Map").get_children():
		if child is CameraPoint:
			if child.camera == camera:
				child.select()
			else:
				child.unselect()
	selected_camera = camera
	white_bars.play()
	camera_changed.emit(camera)

enum Camera {CAM_1A, CAM_1B, CAM_1C, CAM_2A, CAM_2B, CAM_3, CAM_4A, CAM_4B, CAM_5, CAM_6, CAM_7, DOOR, OFFICE}
