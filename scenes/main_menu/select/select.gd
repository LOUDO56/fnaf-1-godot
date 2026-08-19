extends Sprite2D

signal changed_button(position_y: float)

@onready var select_sound := $"Select Sound"

var current_position_y := 0.0

func _ready() -> void:
	visible = false

func _on_button_hovered(y_position: float) -> void:
	if current_position_y == y_position:
		return
	current_position_y = y_position
	visible = true
	position.y = y_position
	select_sound.play()
	changed_button.emit(y_position)
