class_name Animatronics extends Node2D

@onready var bonnie: Bonnie = $"Bonnie"
@onready var chica: Chica = $"Chica"
@onready var freddy: Freddy = $"Freddy"
@onready var foxy: Foxy = $"Foxy"

func get_animatronic_in_office() -> Animatronic:
	for animatronic: Animatronic in [freddy, bonnie, chica, foxy]:
		if animatronic.in_office():
			return animatronic
	return null

enum Character {FREDDY, BONNIE, CHICA, FOXY}
