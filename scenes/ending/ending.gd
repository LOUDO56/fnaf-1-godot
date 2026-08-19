extends Fade

@onready var night_5_ending = $"Sprites/Night 5"
@onready var night_6_ending = $"Sprites/Night 6"
@onready var night_7_ending = $"Sprites/Night 7"

func _ready() -> void:
	if PlayerData.night < 5:
		PlayerData.night = 5
	match PlayerData.night:
		5: sprite = night_5_ending
		6: sprite = night_6_ending
		7: sprite = night_7_ending
	sprite.visible = true
