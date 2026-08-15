class_name Death extends CanvasLayer

@onready var death_statics := $"Death Statics"
@onready var death_sound := $"Death Sound"

func show_death_statics():
	Globals.state = Globals.State.DIED
	death_statics.visible = true
	death_sound.play()
