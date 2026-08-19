class_name Animatronics extends Node2D

var ai_level_night := {
	1: {
		Freddy: 0,
		Bonnie: 0,
		Chica: 0,
		Foxy: 0,
	},
	2: {
		Freddy: 0,
		Bonnie: 3,
		Chica: 1,
		Foxy: 1,
	},
	3: {
		Freddy: 1,
		Bonnie: 0,
		Chica: 5,
		Foxy: 2,
	},
	4: {
		Freddy: 0,
		Bonnie: 2,
		Chica: 4,
		Foxy: 6,
	},
	5: {
		Freddy: 3,
		Bonnie: 5,
		Chica: 7,
		Foxy: 5,
	},
	6: {
		Freddy: 4,
		Bonnie: 10,
		Chica: 12,
		Foxy: 16,
	}
}


@onready var bonnie: Bonnie = $"Bonnie"
@onready var chica: Chica = $"Chica"
@onready var freddy: Freddy = $"Freddy"
@onready var foxy: Foxy = $"Foxy"

@export var office: Office

func _ready() -> void:
	Events.power_off.connect(_on_power_off)
	office.left_door.setup(self)
	office.right_door.setup(self)
	office.office_stage.animatronics = self
	office.freddy_jingle.setup(self.freddy)
	_apply_ai_level_by_current_night()

func get_animatronic_in_office() -> Animatronic:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		if animatronic.in_office():
			return animatronic
	return null

func every_animatronic_max_ai() -> bool:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		if animatronic.ai_level < 20:
			return false
	return true

func _apply_ai_level_by_current_night() -> void:
	if PlayerData.night == 7:
		for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
			animatronic.ai_level = PlayerData.night_7_ai_level[animatronic.get_script()]
		return
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		animatronic.ai_level = ai_level_night[PlayerData.night][animatronic.get_script()]

func _on_power_off() -> void:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		animatronic.process_mode = Node.PROCESS_MODE_DISABLED
		animatronic.cancel_jumpscare() # prevent animatronic in office to jumpscare when power is off
