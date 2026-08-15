class_name Foxy extends Animatronic

const DEFAULT_ATTACK_TIME := 25.0
const FAST_ATTACK_TIME := 2.0

@onready var always_fail_timer = $"Always Fail Timer"
@onready var foxy_attack_timer = $"Foxy Attack Timer"
@onready var knock_door_audio = $"Knock Door Audio"

const RANDOM_ALWAYS_FAIL_SECONDS = [0.83, 16.67]

var step_attack := 0
var always_fail_mode := false

func _ready() -> void:
	current_position = CameraMap.Camera.CAM_1C

func move_ai() -> void:
	if always_fail_mode or is_stalled:
		return
	if step_attack < 3:
		step_attack += 1
		if step_attack == 3:
			foxy_attack_timer.start(DEFAULT_ATTACK_TIME)

func get_character() -> Animatronics.Character:
	return Animatronics.Character.FOXY

func _attack_blocked() -> void:
	knock_door_audio.play()
	current_position = CameraMap.Camera.CAM_1C
	step_attack = 0
	foxy_attack_timer.stop()

func block_moving() -> void:
	always_fail_mode = false
	always_fail_timer.stop()
	super.block_moving()

func is_coming():
	return step_attack == 3

func accelerate_foxy_attack():
	foxy_attack_timer.stop()
	foxy_attack_timer.start(FAST_ATTACK_TIME)

func trigger_always_fail() -> void:
	allow_moving() # to not make him stalled indefinitely
	if step_attack >= 2:
		return
	always_fail_mode = true
	always_fail_timer.stop()
	always_fail_timer.start(randf_range(RANDOM_ALWAYS_FAIL_SECONDS[0], RANDOM_ALWAYS_FAIL_SECONDS[1]))

func _on_always_fail_timer_timeout() -> void:
	always_fail_mode = false

func _play_step_sound() -> void:
	pass

func _on_foxy_attack_timer_timeout() -> void:
	if step_attack < 3:
		return
	on_try_attack.emit()
