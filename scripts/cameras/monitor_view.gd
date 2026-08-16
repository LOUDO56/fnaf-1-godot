extends Camera2D

const CAMERA_SPEED = 75

@onready var cooldown_camera_side := $"Cooldown Camera Side"

var camera_position_x := 0.0
var moving_side = "right"
var camera_moving = true
var current_camera_sprite_width: float

func _process(delta: float) -> void:
	if camera_moving and current_camera_sprite_width:
		if moving_side == "right":
			position.x += CAMERA_SPEED * delta
		else:
			position.x -= CAMERA_SPEED * delta
		
		if position.x >= current_camera_sprite_width:
			moving_side = "left"
			camera_moving = false
			cooldown_camera_side.start()
		if position.x <= 0:
			moving_side = "right"
			camera_moving = false
			cooldown_camera_side.start()

func _on_cooldown_camera_side_timeout() -> void:
	camera_moving = true

func _on_watching_cameras_sprite_changed(camera_sprite_width: float) -> void:
	current_camera_sprite_width = camera_sprite_width - get_viewport_rect().size.x
