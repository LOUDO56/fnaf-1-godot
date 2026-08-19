class_name CameraSprites extends Node2D

@export var camera_disabled_text: Sprite2D

var animatronics: Animatronics
var show_golden_freddy := false

func setup(p_animatronics: Animatronics) -> void:
	animatronics = p_animatronics

func get_sprite_from_camera(camera: CameraMap.Camera) -> Sprite2D:
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
	if not animatronics.bonnie.on_stage() and not animatronics.chica.on_stage() and not animatronics.freddy.on_stage():
		return $"Points/CAM 1A (Show Stage)/No Animatronics"
	elif not animatronics.bonnie.on_stage() and not animatronics.chica.on_stage():
		if randi() % 10 == 0:
			return $"Points/CAM 1A (Show Stage)/Freddy Look Camera"
		return $"Points/CAM 1A (Show Stage)/Freddy"
	elif not animatronics.bonnie.on_stage():
		return $"Points/CAM 1A (Show Stage)/Freddy Chica"
	elif not animatronics.chica.on_stage():
		return $"Points/CAM 1A (Show Stage)/Bonnie Freddy"
	return $"Points/CAM 1A (Show Stage)/Every Animatronics"
	
func _get_diner_area_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_1B and animatronics.chica.current_position == CameraMap.Camera.CAM_1B:
		return $"Points/CAM 1B (Dining Area)/Chica 2"
	elif animatronics.bonnie.current_position == CameraMap.Camera.CAM_1B:
		if animatronics.bonnie.variant == 0:
			return $"Points/CAM 1B (Dining Area)/Bonnie"
		return $"Points/CAM 1B (Dining Area)/Bonnie 2"
	elif animatronics.chica.current_position == CameraMap.Camera.CAM_1B:
		return $"Points/CAM 1B (Dining Area)/Chica"
	elif animatronics.freddy.current_position == CameraMap.Camera.CAM_1B:
		return $"Points/CAM 1B (Dining Area)/Freddy"
	return $"Points/CAM 1B (Dining Area)/No Animatronic"

func _get_pirate_cove_sprite() -> Sprite2D:
	match animatronics.foxy.step_attack:
		0:
			return $"Points/CAM 1C (Pirate Cove)/Idle"
		1:
			return $"Points/CAM 1C (Pirate Cove)/1"
		2:
			return $"Points/CAM 1C (Pirate Cove)/2"
		3:
			if randi_range(0, 10) == 0:
				return $"Points/CAM 1C (Pirate Cove)/It's me"
			else:
				return $"Points/CAM 1C (Pirate Cove)/3"
	return $"Points/CAM 1C (Pirate Cove)/Idle"
	
func _get_west_hall_sprite() -> Sprite2D:
	if animatronics.foxy.is_coming():
		return $"Points/CAM 2A (West Hall)/No Light"
	if (randi() % 10 >= 7):
		if animatronics.bonnie.current_position == CameraMap.Camera.CAM_2A:
			return $"Points/CAM 2A (West Hall)/Light Bonnie"
		return $"Points/CAM 2A (West Hall)/Light"
	else:
		return $"Points/CAM 2A (West Hall)/No Light"

func _get_west_hall_corner_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_2B:
		# TODO: glitch variant?
		return $"Points/CAM 2B (W Hall Corner)/Bonnie"
	elif show_golden_freddy:
		return $"Points/CAM 2B (W Hall Corner)/Golden Freddy Poster"
	else:
		if randi() % 100 == 0:
			return $"Points/CAM 2B (W Hall Corner)/Freddy Poster"
		return $"Points/CAM 2B (W Hall Corner)/No Animatronic"
	
func _get_supply_closet_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_3:
		return $"Points/CAM 3 (Supply Closet)/Bonnie"
	return $"Points/CAM 3 (Supply Closet)/No Animatronic"
	
func _get_east_hall_sprite() -> Sprite2D:
	if animatronics.chica.current_position == CameraMap.Camera.CAM_4A:
		if animatronics.chica.variant == 0:
			return $"Points/CAM 4A (East Hall)/Chica"
		return $"Points/CAM 4A (East Hall)/Chica 2"
	elif animatronics.freddy.current_position == CameraMap.Camera.CAM_4A:
		return $"Points/CAM 4A (East Hall)/Freddy"
	if randi() % 100 == 0:
		if randi() % 2 == 0:
			return $"Points/CAM 4A (East Hall)/Children"
		return $"Points/CAM 4A (East Hall)/It's me"
	return $"Points/CAM 4A (East Hall)/No Animatronic"

func _get_east_hall_corner_sprite() -> Sprite2D:
	if animatronics.freddy.current_position == CameraMap.Camera.CAM_4B:
		return $"Points/CAM 4B (E Hall Corner)/Freddy"
	elif animatronics.chica.current_position == CameraMap.Camera.CAM_4B:
		#TODO: glitch variant?
		return $"Points/CAM 4B (E Hall Corner)/Chica"
	if randi() % 25 == 0:
		return [
			$"Points/CAM 4B (E Hall Corner)/News", 
			$"Points/CAM 4B (E Hall Corner)/News 2", 
			$"Points/CAM 4B (E Hall Corner)/News 3",
			 $"Points/CAM 4B (E Hall Corner)/News 4"
			].pick_random()
	return $"Points/CAM 4B (E Hall Corner)/No Animatronic"
	
func _get_backstage_sprite() -> Sprite2D:
	if animatronics.bonnie.current_position == CameraMap.Camera.CAM_5:
		if animatronics.bonnie.variant == 0:
			return $"Points/CAM 5 (Backstage)/Bonnie"
		return $"Points/CAM 5 (Backstage)/Bonnie 2"
	if randi() % 20 == 0:
		return $"Points/CAM 5 (Backstage)/Looking"
	return $"Points/CAM 5 (Backstage)/No Animatronic"
	
func _get_kitchen_sprite() -> Sprite2D:
	return $"Points/CAM 6 (Kitchen)/Nothing"
	
func _get_restrooms_sprite() -> Sprite2D:
	if animatronics.chica.current_position == CameraMap.Camera.CAM_7:
		if animatronics.chica.variant == 0:
			return $"Points/CAM 7 (Restrooms)/Chica"
		return $"Points/CAM 7 (Restrooms)/Chica 2"
	elif animatronics.freddy.current_position == CameraMap.Camera.CAM_7:
			return $"Points/CAM 7 (Restrooms)/Freddy"
	return $"Points/CAM 7 (Restrooms)/No Animatronic"
	
