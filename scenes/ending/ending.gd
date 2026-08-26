extends Fade

@onready var night_5_ending = $"Sprites/Night 5"
@onready var night_6_ending = $"Sprites/Night 6"
@onready var night_7_ending = $"Sprites/Night 7"

func _ready() -> void:
	if PlayerData.level < 5:
		PlayerData.level = 5
	match PlayerData.level:
		5: sprite = night_5_ending
		6: sprite = night_6_ending
		7: sprite = night_7_ending
	sprite.visible = true
	super._ready()
