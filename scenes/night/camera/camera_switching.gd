class_name CameraSwitching extends Node2D

signal sprite_changed(camera_sprite_width: float)
signal golden_freddy_attack()
signal golden_freddy_appear()
signal golden_freddy_block_attack()

@export var animatronics: Animatronics
@export var office: Office

@onready var current_camera := CameraMap.Camera.CAM_1A
@onready var camera_moving_audio := $"CanvasLayer/Cameras/Audio/Camera Moving Audio"
@onready var monitor_view := $"MonitorView"
@onready var monitor_animation: MonitorAnimation = $"CanvasLayer2/Monitor"
@onready var camera_map: CameraMap = $"CanvasLayer/Cameras/Camera Map"
@onready var camera_disabled_text := $"CanvasLayer/Cameras/Camera Disabled Text"
@onready var foxy_running_animation: AnimatedSprite2D = $"Camera Sprites/Points/CAM 4A (East Hall)/Foxy Running"
@onready var force_camera_down_timer := $"Force Camera Down"
@onready var camera_sprites := $"Camera Sprites"
@onready var garble_effect := $"Camera Effects/Garble Effect"
@onready var breathing_behind_cam := $"Breath Behind Camera"

var current_camera_sprite: Sprite2D
var current_camera_sprite_width: float
var golden_freddy_seen := false

func _ready() -> void:
	visible = false
	camera_sprites.setup(animatronics)
	breathing_behind_cam.setup(animatronics)
	
	# Freddy
	monitor_animation.monitor_closed.connect(animatronics.freddy.on_monitor_closed)
	monitor_animation.monitor_opened.connect(animatronics.freddy.on_monitor_opened)
	camera_map.camera_changed.connect(animatronics.freddy.on_camera_changed)
	
	# Bonnie
	animatronics.bonnie.animatronic_moved.connect(_on_animatronic_moved)
	monitor_animation.monitor_closed.connect(animatronics.bonnie.on_monitor_closed)
	animatronics.bonnie.on_office.connect(_on_animatrionic_enter_office)
	
	# Chica
	animatronics.chica.animatronic_moved.connect(_on_animatronic_moved)
	animatronics.chica.on_office.connect(_on_animatrionic_enter_office)
	monitor_animation.monitor_closed.connect(animatronics.chica.on_monitor_closed)
	camera_map.camera_changed.connect(animatronics.chica.on_camera_changed)
	
	# Foxy
	monitor_animation.monitor_opened.connect(animatronics.foxy.on_monitor_open)
	monitor_animation.monitor_closed.connect(animatronics.foxy.on_monitor_closed)
	camera_map.camera_changed.connect(animatronics.foxy.on_camera_changed)
	animatronics.foxy.attack_blocked.connect(_on_foxy_attack_blocked)
	
	Events.disable_gameplay.connect(_on_disabled_gameplay)
	Events.power_off.connect(_on_power_off)

func _on_monitor_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	if not visible:
		return
	Events.decrease_power_usage.emit()
	visible = false
	camera_disabled_text.visible = false
	camera_moving_audio.stop()
	$CanvasLayer/Cameras.visible = false
	camera_map.white_bars.stop()
	
	foxy_running_animation.visible = false
	if golden_freddy_seen:
		golden_freddy_attack.emit()
		camera_sprites.show_golden_freddy = false
	

func _on_monitor_monitor_opened() -> void:
	$CanvasLayer/Cameras.visible = true
	Events.increase_power_usage.emit()
	monitor_view.make_current()
	visible = true
	change_sprite(camera_sprites.get_sprite_from_camera(current_camera))
	camera_moving_audio.play()
	camera_map.select_camera(camera_map.selected_camera)
	if animatronics.bonnie.in_office() or animatronics.chica.in_office():
		force_camera_down_timer.start()
	if golden_freddy_seen:
		golden_freddy_block_attack.emit()
		golden_freddy_seen = false
	
func _on_camera_map_camera_changed(camera: CameraMap.Camera) -> void:
	current_camera = camera
	change_sprite(camera_sprites.get_sprite_from_camera(camera))
	if animatronics.foxy.is_coming() and current_camera == CameraMap.Camera.CAM_2A:
		foxy_running_animation.play("default")
		foxy_running_animation.visible = true
	else:
		foxy_running_animation.visible = false
		
	if camera_sprites.show_golden_freddy and not golden_freddy_seen and camera == CameraMap.Camera.CAM_2B\
	and animatronics.bonnie.current_position != CameraMap.Camera.CAM_2B:
		golden_freddy_seen = true
		golden_freddy_appear.emit()

	
func change_sprite(new_sprite: Sprite2D) -> void:
	_hide_all_camera()
	current_camera_sprite = new_sprite
	current_camera_sprite.visible = true
	sprite_changed.emit(current_camera_sprite.texture.get_width())
	if camera_map.selected_camera == CameraMap.Camera.CAM_6:
		animatronics.chica.increase_kitchen_sound()
	if current_camera == CameraMap.Camera.CAM_1C:
		animatronics.foxy.increase_singing()
		
func reload_current_camera_sprite() -> void:
	change_sprite(camera_sprites.get_sprite_from_camera(current_camera))
		
func _on_flicker_light_west_hall() -> void:
	if current_camera != CameraMap.Camera.CAM_2A:
		return
	change_sprite(camera_sprites.get_sprite_from_camera(CameraMap.Camera.CAM_2A))
	
func _hide_all_camera():
	for child in camera_sprites.get_node("Points").get_children():
		for sprite in child.get_children():
			if sprite is Sprite2D:
				sprite.visible = false
	
func _on_force_camera_down_timeout() -> void:
	animatronics.get_animatronic_in_office().play_jumpscare()
	
func _on_animatronic_moved(old_position: CameraMap.Camera, new_position: CameraMap.Camera):
	if visible and (old_position == current_camera or new_position == current_camera):
		garble_effect.garble_camera()

func _on_foxy_attack_blocked() -> void:
	monitor_animation.close_monitor()
	
func _on_animatrionic_enter_office() -> void:
	if not visible:
		return
	force_camera_down_timer.start()
	breathing_behind_cam.start_breath_sound()

func _on_disabled_gameplay() -> void:
	monitor_animation.close_monitor()
	breathing_behind_cam.pick_breath_sound_timer.stop()
	
func _on_power_off() -> void:
	monitor_animation.close_monitor()
	force_camera_down_timer.stop()
	visible = false

func _on_golden_freddy_appear_camera() -> void:
	camera_sprites.show_golden_freddy = true
