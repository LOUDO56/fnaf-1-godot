class_name Power extends Node2D

@export var usage: PowerUsage

const NIGHT_POWER_PENALTY_TIMER := {
	1: 0,
	2: 6,
	3: 5,
	4: 4,
	5: 3,
	6: 3,
	7: 3
}

@onready var first_digit = $"Percent/First Digit"
@onready var second_digit = $"Percent/Second Digit"
@onready var drain_timer = $"Drain Timer"
@onready var penalty_timer = $"Penalty Timer"

var power := 999

func _ready() -> void:
	_update_power_sprite_value()
	Events.jumpscare_started.connect(_on_jumpscare_started)
	Events.update_power_by_amount.connect(_on_power_updated)
	var penalty_timer_value = NIGHT_POWER_PENALTY_TIMER[PlayerData.level]
	if penalty_timer_value != 0:
		penalty_timer.start(penalty_timer_value)

func _on_penalty_timer_timeout() -> void:
	_handle_decrease_power(-1)
	
func _on_drain_timer_timeout() -> void:
	_handle_decrease_power(-1 - (usage.consumption_level - 1))
	
func _handle_decrease_power(to_remove: int) -> void:
	if power > 0:
		power += to_remove
		_update_power_sprite_value()
	else:
		drain_timer.stop()
		penalty_timer.stop()
		Events.power_off.emit()
		get_parent().visible = false

func _update_power_sprite_value() -> void:
	var normalized_power := int(power / 10.0)
	first_digit.visible = normalized_power >= 10
	_update_digit(first_digit, int(normalized_power / 10.0))
	_update_digit(second_digit, int(normalized_power) % 10)

func _update_digit(digits: Node2D, number: int) -> void:
	for digit in digits.get_children():
		digit.visible = digit.name == str(number)
		
func _on_jumpscare_started(_time: float, _animatronic: Animatronic) -> void:
	set_process(false)
	
func _on_power_updated(amount: int) -> void:
	power += amount
