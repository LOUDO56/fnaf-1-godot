class_name MonitorAnimation extends Node2D

signal monitor_opened()
signal monitor_closed(last_camera_viewed: CameraMap.Camera)

@export var camera_switching: CameraSwitching

@onready var watch_cameras_animation: AnimatedSprite2D = $"Watch Monitor Animation"
@onready var monitor_camera_sound = $"Monitor Camera Sound"
@onready var monitor_sprite = $"Monitor Sprite"

var mouse_inside_zone := false
var is_watching_cameras := false
var monitor_disabled := false

func _ready() -> void:
	watch_cameras_animation.visible = false
	Events.disable_gameplay.connect(_on_disable_gameplay)

func _on_watch_cameras_zone_mouse_entered() -> void:
	if monitor_disabled or not Libs.is_mouse_in_window(get_viewport()) or mouse_inside_zone or watch_cameras_animation.is_playing():
		return
	
	monitor_sprite.visible = false
	mouse_inside_zone = true
	watch_cameras_animation.visible = true
	
	if is_watching_cameras:
		close_monitor()
	else:
		open_monitor()

func close_monitor():
	if not is_watching_cameras:
		return
	monitor_camera_sound.play()
	watch_cameras_animation.visible = true
	watch_cameras_animation.play_backwards("default")
	is_watching_cameras = false
	monitor_closed.emit(camera_switching.current_camera)

func open_monitor():
	if is_watching_cameras:
		return
	monitor_camera_sound.play()
	watch_cameras_animation.play("default")
	is_watching_cameras = true

func _on_watch_cameras_zone_mouse_exited() -> void:
	if monitor_disabled or not Libs.is_mouse_in_window(get_viewport()):
		return
	monitor_sprite.visible = true
	mouse_inside_zone = false
	
func _on_watch_monitor_animation_animation_finished() -> void:
	watch_cameras_animation.visible = false
	if is_watching_cameras:
		monitor_opened.emit()
		
func _on_disable_gameplay():
	monitor_disabled = true
