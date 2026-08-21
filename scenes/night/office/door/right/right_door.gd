class_name RightDoor extends Door

@export var left_door: LeftDoor

func setup_animatronics_behavior() -> void:
	animatronics.chica.on_at_door.connect(_on_animatronic_at_door)
	animatronics.chica.on_left_door.connect(_on_animatronic_left_door)

	animatronics.chica.on_try_attack.connect(
		func(): _try_attack(animatronics.chica, side, true))
	animatronics.freddy.on_try_attack.connect(
		func(): _try_attack(animatronics.freddy, side))
		
func change_door_sprite() -> void:
	if animatronics.chica.at_door():
		_play_stinger()
		office_stage.change_stage(OfficeStage.Stage.RIGHT_CHICA_LIGHT_ON)
	else:
		office_stage.change_stage(OfficeStage.Stage.RIGHT_LIGHT_ON)
		
func stop_light_other_door() -> void:
	left_door.turn_off_light(false)
