extends Node2D

const CAMERA_SPEED = 75
const FLICKER_TIMER = 0.027

@export var animatronics: Animatronics

@onready var current_camera := CameraMap.Camera.CAM_1A
@onready var statics := $"CanvasLayer/Cameras/Statics"
@onready var white_bars: WhiteBars = $"CanvasLayer/Cameras/White Bars"
@onready var camera_moving_audio := $"CanvasLayer/Cameras/Audio/Camera Moving Audio"
@onready var monitor_view := $"MonitorView"
@onready var cooldown_camera_side := $"Cooldown Camera Side"
@onready var camera_outline := $"CanvasLayer/Cameras/Camera Outline"
@onready var camera_map: CameraMap = $"CanvasLayer/Cameras/Camera Map"
@onready var camera_disabled_text = $"CanvasLayer/Cameras/Camera Disabled Text"

var camera_position_x := 0.0
var moving_side = "right"
var camera_moving = true
var current_camera_sprite: Sprite2D
var current_camera_sprite_width: float
var flicker_time: float

func _process(delta: float) -> void:

	if camera_moving and current_camera_sprite_width:
		if moving_side == "right":
			monitor_view.position.x += CAMERA_SPEED * delta
		else:
			monitor_view.position.x -= CAMERA_SPEED * delta
		
		if monitor_view.position.x >= current_camera_sprite_width:
			moving_side = "left"
			camera_moving = false
			cooldown_camera_side.start()
		if monitor_view.position.x <= 0:
			moving_side = "right"
			camera_moving = false
			cooldown_camera_side.start()
		
	flicker_time += delta
	if flicker_time >= FLICKER_TIMER:
		if current_camera == CameraMap.Camera.CAM_2A:
			_change_sprite(_get_west_hall_sprite())
		var random = randf_range(0.05, 0.35)
		statics.modulate.a = random
		flicker_time = 0.0

func _on_monitor_monitor_closed() -> void:
	visible = false
	camera_disabled_text.visible = false
	camera_moving_audio.stop()
	$CanvasLayer/Cameras.visible = false

func _on_monitor_monitor_opened() -> void:
	$CanvasLayer/Cameras.visible = true
	monitor_view.make_current()
	visible = true
	_change_sprite(_get_sprite_from_camera(current_camera))
	camera_moving_audio.play()
	camera_map.select_camera(camera_map.selected_camera_id)
	
	
func _on_camera_map_camera_changed(id: CameraMap.Camera) -> void:
	current_camera = id
	_change_sprite(_get_sprite_from_camera(id))
	
func _change_sprite(new_sprite: Sprite2D) -> void:
	_hide_all_camera()
	current_camera_sprite = new_sprite
	current_camera_sprite.visible = true
	current_camera_sprite_width = current_camera_sprite.texture.get_width() - get_viewport_rect().size.x

	
func _hide_all_camera():
	for child in get_node("Points").get_children():
		for sprite in child.get_children():
			if sprite is Sprite2D:
				sprite.visible = false

func _on_cooldown_camera_side_timeout() -> void:
	camera_moving = true
	
func _get_sprite_from_camera(camera: CameraMap.Camera) -> Sprite2D:
	camera_disabled_text.visible = false
	match camera:
		CameraMap.Camera.CAM_1A:
			return _get_show_stage_sprite()
		CameraMap.Camera.CAM_1B:
			return _get_diner_area_sprite()
		CameraMap.Camera.CAM_1C:
			return _get_pirate_cove_sprite()
		CameraMap.Camera.CAM_2A:
			return _get_west_hall_sprite()
		CameraMap.Camera.CAM_2B:
			return _get_west_hall_corner_sprite()
		CameraMap.Camera.CAM_3:
			return _get_supply_closet_sprite()
		CameraMap.Camera.CAM_4A:
			return _get_east_hall_sprite()
		CameraMap.Camera.CAM_4B:
			return _get_east_hall_corner_sprite()
		CameraMap.Camera.CAM_5:
			return _get_backstage_sprite()
		CameraMap.Camera.CAM_6:
			camera_disabled_text.visible = true
			return _get_kitchen_sprite()
		CameraMap.Camera.CAM_7:
			return _get_restrooms_sprite()
	return _get_show_stage_sprite()
	
func _get_show_stage_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position != CameraMap.Camera.CAM_1A and animatronics.chica.current_position != CameraMap.Camera.CAM_1A:
		return $"Points/CAM 1A (Show Stage)/Freddy"
	elif animatronics.bonnie.current_position != CameraMap.Camera.CAM_1A:
		return $"Points/CAM 1A (Show Stage)/Freddy Chica"
	elif animatronics.chica.current_position != CameraMap.Camera.CAM_1A:
		return $"Points/CAM 1A (Show Stage)/Bonnie Freddy"
	return $"Points/CAM 1A (Show Stage)/Every Animatronics"
	
func _get_diner_area_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_1B and animatronics.chica.current_position == CameraMap.Camera.CAM_1B:
		return $"Points/CAM 1B (Dining Area)/Chica 2"
	elif animatronics.bonnie.current_position == CameraMap.Camera.CAM_1B:
		if animatronics.bonnie.variant == 0:
			return $"Points/CAM 1B (Dining Area)/Bonnie"
		else:
			return $"Points/CAM 1B (Dining Area)/Bonnie 2"
	elif animatronics.chica.current_position == CameraMap.Camera.CAM_1B:
			return $"Points/CAM 1B (Dining Area)/Chica"
	return $"Points/CAM 1B (Dining Area)/No Animatronic"

func _get_pirate_cove_sprite() -> Sprite2D:
	return $"Points/CAM 1C (Pirate Cove)/Idle"
	
func _get_west_hall_sprite() -> Sprite2D:
	if (randi() % 10 >= 7):
		if animatronics.bonnie.current_position == CameraMap.Camera.CAM_2A:
			return $"Points/CAM 2A (West Hall)/Light Bonnie"
		else:
			return $"Points/CAM 2A (West Hall)/Light"
	else:
		return $"Points/CAM 2A (West Hall)/No Light"

func _get_west_hall_corner_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_2B:
		# TODO: glitch variant?
		return $"Points/CAM 2B (W Hall Corner)/Bonnie"
	else:
		return $"Points/CAM 2B (W Hall Corner)/No Animatronic"
	
func _get_supply_closet_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_3:
		return $"Points/CAM 3 (Supply Closet)/Bonnie"
	else:
		return $"Points/CAM 3 (Supply Closet)/No Animatronic"
	
func _get_east_hall_sprite() -> Sprite2D:
	if animatronics.chica.current_position == CameraMap.Camera.CAM_4A:
		if animatronics.chica.variant == 0:
			return $"Points/CAM 4A (East Hall)/Chica"
		else:
			return $"Points/CAM 4A (East Hall)/Chica 2"
	return $"Points/CAM 4A (East Hall)/No Animatronic"

func _get_east_hall_corner_sprite() -> Sprite2D:
	if animatronics.chica.current_position == CameraMap.Camera.CAM_4B:
		#TODO: glitch variant?
		return $"Points/CAM 4B (E Hall Corner)/Chica"
	return $"Points/CAM 4B (E Hall Corner)/No Animatronic"
	
func _get_backstage_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_5:
		if animatronics.bonnie.variant == 0:
			return $"Points/CAM 5 (Backstage)/Bonnie"
		else:
			return $"Points/CAM 5 (Backstage)/Bonnie 2"
	return $"Points/CAM 5 (Backstage)/No Animatronic"
	
func _get_kitchen_sprite() -> Sprite2D:
	return $"Points/CAM 6 (Kitchen)/Nothing"
	
func _get_restrooms_sprite() -> Sprite2D:
	if animatronics.chica.current_position == CameraMap.Camera.CAM_7:
		if animatronics.chica.variant == 0:
			return $"Points/CAM 7 (Restrooms)/Chica"
		else:
			return $"Points/CAM 7 (Restrooms)/Chica 2"
	return $"Points/CAM 7 (Restrooms)/No Animatronic"
