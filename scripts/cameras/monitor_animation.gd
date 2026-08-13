class_name MonitorAnimation extends Node2D

signal monitor_opened()
signal monitor_closed()

@onready var watch_cameras_animation: AnimatedSprite2D = $"Watch Monitor Animation"
@onready var monitor_camera_sound = $"Monitor Camera Sound"
@onready var monitor_sprite = $"Monitor Sprite"


var mouse_inside_zone = false
var is_watching_cameras = false

func _ready() -> void:
	watch_cameras_animation.visible = false

func _on_watch_cameras_zone_mouse_entered() -> void:
	if not Libs.is_mouse_in_window(get_viewport()):
		return
	if mouse_inside_zone:
		return
	if watch_cameras_animation.is_playing():
		return
	
	monitor_sprite.visible = false
	mouse_inside_zone = true
	watch_cameras_animation.visible = true
	monitor_camera_sound.play()
	
	if is_watching_cameras:
		watch_cameras_animation.play_backwards("default")
		is_watching_cameras = false
		monitor_closed.emit()
	else:
		watch_cameras_animation.play("default")
		is_watching_cameras = true

func _on_watch_cameras_zone_mouse_exited() -> void:
	if not Libs.is_mouse_in_window(get_viewport()):
		return
	monitor_sprite.visible = true
	mouse_inside_zone = false

func _on_watch_camera_animation_animation_finished() -> void:
	watch_cameras_animation.visible = false
	if is_watching_cameras:
		monitor_opened.emit()
