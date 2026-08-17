extends Node2D

const NEXT_SCENE := "res://scenes/game.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(NEXT_SCENE)

func _process(_delta: float) -> void:
	if ResourceLoader.load_threaded_get_status(NEXT_SCENE) == ResourceLoader.THREAD_LOAD_LOADED:
		var scene := ResourceLoader.load_threaded_get(NEXT_SCENE)
		get_tree().change_scene_to_packed(scene)
	
