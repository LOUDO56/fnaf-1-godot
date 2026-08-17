class_name Animatronics extends Node2D

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

func get_animatronic_in_office() -> Animatronic:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		if animatronic.in_office():
			return animatronic
	return null
	
func _on_power_off() -> void:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		animatronic.set_process(false)
		animatronic.cancel_jumpscare() # prevent animatronic in office to jumpscare when power is off

enum Character {FREDDY, BONNIE, CHICA, FOXY}
