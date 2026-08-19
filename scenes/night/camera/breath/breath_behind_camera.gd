class_name BreathBehindCamera extends Node2D

@onready var pick_breath_sound_timer := $"Pick Breath Sound"
@export var monitor_animation: MonitorAnimation

var animatronics: Animatronics

func setup(p_animatronics: Animatronics) -> void:
	animatronics = p_animatronics
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	
func _on_monitor_opened() -> void:
	start_breath_sound()
	
func start_breath_sound() -> void:
	var animatronic_in_office = animatronics.get_animatronic_in_office()
	if animatronic_in_office != null and animatronic_in_office is Bonnie or animatronic_in_office is Chica:
		pick_breath_sound_timer.start()

func _on_pick_breath_sound_timeout() -> void:
	var animatronic_office = animatronics.get_animatronic_in_office()
	if animatronic_office == null:
		return
	animatronic_office.breathing_sounds.pick_random().play()
