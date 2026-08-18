class_name GoldenFreddy extends Animatronic

signal appear_camera

@onready var golden_freddy_sprite := $"Golden Freddy Sprite"
@onready var golden_freddy_laugh := $"Laugh Giggle Girl"
@onready var jumpscare_timer := $"Golden Freddy Jumpscare Timer"
@onready var easter_egg_timer := $"Enable Easter Egg Timer"
@onready var hallucination := preload("res://scenes/easter_eggs/it's_me.tscn").instantiate()

func move_ai() -> void:
	pass
	
func _attack_blocked() -> void:
	pass

func _on_enable_easter_egg_timer_timeout() -> void:
	if randi() % 32_768 == 0:
		easter_egg_timer.stop()
		appear_camera.emit()

func _on_switching_cameras_golden_freddy_block_attack() -> void:
	jumpscare_timer.stop()
	golden_freddy_sprite.visible = false

func _on_golden_freddy_jumpscare_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/easter_eggs/creepy_end.tscn")

func _on_switching_cameras_golden_freddy_appear() -> void:
	golden_freddy_sprite.visible = true
	golden_freddy_laugh.play()

func _on_switching_cameras_golden_freddy_attack() -> void:
	get_parent().add_child(hallucination)
	jumpscare_timer.start()
