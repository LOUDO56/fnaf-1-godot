extends Node2D


func _on_next_frame_timer_timeout() -> void:
	$"Bonnie Eye".visible = true
	$"Main Screen Timer".start()

func _on_main_screen_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
