class_name Doors extends Node2D

@onready var left_door_animation = $"Left/Left Door Animation"
@onready var right_door_animation = $"Right/Right Door Animation"
@onready var door_toggle_sound = $"Door Toggle Sound"
@onready var door_light_sound = $"Door Light Sound"
@onready var stringer_sound = $"Stinger Sound"

@export var left_door: Door
@export var right_door: Door
@export var office_stage: OfficeStage

var animatronics: Animatronics

var flicker_light_count := 0.0
var play_stringer_sound_left := false
var play_stringer_sound_right := false

func _ready() -> void:
	Events.power_off.connect(_on_power_off)

func setup_animatronics_behavior(p_animatronics: Animatronics) -> void:
	animatronics = p_animatronics
	animatronics.bonnie.on_at_door.connect(_on_bonnie_at_door)
	animatronics.bonnie.on_left_door.connect(_on_bonnie_left_door)
	
	animatronics.chica.on_at_door.connect(_on_chica_at_door)
	animatronics.chica.on_left_door.connect(_on_chica_left_door)

	animatronics.bonnie.on_try_attack.connect(
		func(): _try_attack(animatronics.bonnie, left_door, true))
	animatronics.chica.on_try_attack.connect(
		func(): _try_attack(animatronics.chica, right_door, true))
	animatronics.freddy.on_try_attack.connect(
		func(): _try_attack(animatronics.freddy, right_door))
	animatronics.foxy.on_try_attack.connect(
		func(): _try_attack(animatronics.foxy, left_door, false, true))

func _process(delta: float) -> void:
	flicker_light_count += delta
	if flicker_light_count < 0.027:
		return
	flicker_light_count = 0

	if (randi() % 10 > 7):
		door_light_sound.volume_db = -100
		office_stage.change_stage(OfficeStage.Stage.NORMAL)
	else:
		door_light_sound.volume_db = 0
		if left_door.is_light_on:
			if animatronics.bonnie.at_door():
				_play_stinger_sound("left")
				office_stage.change_stage(OfficeStage.Stage.LEFT_BONNIE_LIGHT_ON)
			else:
				office_stage.change_stage(OfficeStage.Stage.LEFT_LIGHT_ON)
		if right_door.is_light_on:
			if animatronics.chica.at_door():
				_play_stinger_sound("right")
				office_stage.change_stage(OfficeStage.Stage.RIGHT_CHICA_LIGHT_ON)
			else:
				office_stage.change_stage(OfficeStage.Stage.RIGHT_LIGHT_ON)
		
func stop_light_sound():
	door_light_sound.stop()

func _on_door_buttons_toggle_door(side: String, close: bool) -> void:
	var door_animation: AnimatedSprite2D
	if side == "left":
		door_animation = left_door_animation
	if side == "right":
		door_animation = right_door_animation
		
	if close:
		Events.increase_power_usage.emit()
		door_animation.play("default")
	else:
		Events.decrease_power_usage.emit()
		door_animation.play_backwards("default")
		
	door_toggle_sound.play()


func _on_door_buttons_toggle_light(side: String, on: bool) -> void:
	if on:
		door_light_sound.play()
		_play_stinger_sound(side)
	else:
		door_light_sound.stop()


	if not on:
		return

	if side == "left":
		right_door.turn_off_light()
	else:
		left_door.turn_off_light()

func _play_stinger_sound(side) -> void:
	if side == "left" and play_stringer_sound_left:
		stringer_sound.play()
		play_stringer_sound_left = false
	if side == "right" and play_stringer_sound_right:
		stringer_sound.play()
		play_stringer_sound_right = false
		
func _on_bonnie_at_door() -> void:
	play_stringer_sound_left = true
	
func _on_bonnie_left_door() -> void:
	play_stringer_sound_left = false

func _on_chica_at_door() -> void:
	play_stringer_sound_right = true
	
func _on_chica_left_door() -> void:
	play_stringer_sound_right = false

func _on_power_off() -> void:
	set_process(false)

func _try_attack(animatronic: Animatronic, door: Door, imminent_death := false, instant_jumpscare := false) -> void:
	if not door.can_enter_office():
		animatronic.step_back()
		return
	animatronic.enter_office()
	if imminent_death:
		door.enter_imminent_death()
	if instant_jumpscare:
		animatronic.play_jumpscare()
		
		
