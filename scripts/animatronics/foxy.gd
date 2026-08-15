class_name Foxy extends Animatronic

@onready var always_fail_timer = $"Always Fail Timer"

const RANDOM_ALWAYS_FAIL_SECONDS = [0.83, 16.67]

var step_attack := 0
var always_fail_mode := false

func _ready() -> void:
	current_position = CameraMap.Camera.CAM_1C

func move_ai() -> void:
	if always_fail_mode:
		return
	step_attack += 1
	
func block_moving() -> void:
	always_fail_mode = false
	always_fail_timer.stop()
	super.block_moving()

func trigger_always_fail() -> void:
	allow_moving() # to not make him stalled indefinitely
	if step_attack >= 2:
		return
	always_fail_mode = true
	always_fail_timer.stop()
	always_fail_timer.start(randf_range(RANDOM_ALWAYS_FAIL_SECONDS[0], RANDOM_ALWAYS_FAIL_SECONDS[1]))

func _on_always_fail_timer_timeout() -> void:
	always_fail_mode = false
