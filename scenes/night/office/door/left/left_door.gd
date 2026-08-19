class_name LeftDoor extends Door

@export var right_door: RightDoor

func setup_animatronics_behavior() -> void:
	animatronics.bonnie.on_at_door.connect(_on_animatronic_at_door)
	animatronics.bonnie.on_left_door.connect(_on_animatronic_left_door)
	
	animatronics.bonnie.on_try_attack.connect(func(): _try_attack(animatronics.bonnie, true))
	animatronics.foxy.on_try_attack.connect(
		func(): _try_attack(animatronics.foxy, false, true))
		
func change_door_sprite() -> void:
	if animatronics.bonnie.at_door():
		_play_stinger()
		office_stage.change_stage(OfficeStage.Stage.LEFT_BONNIE_LIGHT_ON)
	else:
		office_stage.change_stage(OfficeStage.Stage.LEFT_LIGHT_ON)

func stop_light_other_door() -> void:
	right_door.turn_off_light(false)
