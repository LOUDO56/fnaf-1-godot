class_name Power extends Node2D

@export var night_divisor := 9.6
@export var usage: PowerUsage

@onready var first_digit = $"Percent/First Digit"
@onready var second_digit = $"Percent/Second Digit"

var power := 100.0
var power_consume_time := 0.0

func _ready() -> void:
	_update_power_sprite_value()

func _process(delta: float) -> void:
	power_consume_time += delta
	while power_consume_time >= 0.1:
		var base := usage.consumption_level / 10.0
		power = maxf(power - (base + 0.1 / night_divisor) / 10.0, 0.0)
		_update_power_sprite_value()
		power_consume_time -= 0.1

func _update_power_sprite_value() -> void:
	first_digit.visible = power >= 10.0
	_update_digit(first_digit, int(power / 10.0))
	_update_digit(second_digit, int(power) % 10)

func _update_digit(digits: Node2D, number: int) -> void:
	for digit in digits.get_children():
		digit.visible = digit.name == str(number)
