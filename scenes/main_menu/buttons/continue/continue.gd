extends Hover

@onready var current_night := $"Sprite/Current Night"

func _ready() -> void:
	current_night.visible = false

func _on_mouse_entered() -> void:
	current_night.visible = true
	hovered.emit(position.y)

func _on_select_changed_button(position_y: float) -> void:
	if position_y == position.y:
		return
	current_night.visible = false
