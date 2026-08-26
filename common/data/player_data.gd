extends Node

var level := 1
var progress_level := 1
var beat_game := false
var beat6 := false
var beat7 := false

var beating_20_4 := false

var played_phone_guy_voice: Array[int] = []

var level_7_ai_level = {
	Freddy: 1,
	Bonnie: 3,
	Chica: 3,
	Foxy: 1,
}

func _ready() -> void:
	load_save()

func save() -> void:
	var save_file = FileAccess.open("user://freddy", FileAccess.WRITE)
	save_file.store_line(JSON.stringify({
		"level": PlayerData.progress_level,
		"beat_game": PlayerData.beat_game,
		"beat6": PlayerData.beat6,
		"beat7": PlayerData.beat7,
	}))

func load_save() -> void:
	if not FileAccess.file_exists("user://freddy"):
		return
	var save_file = FileAccess.open("user://freddy", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		progress_level = min(5, int(json.data["level"]))
		beat_game = bool(json.data["beat_game"])
		beat6 = bool(json.data["beat6"])
		beat7 = bool(json.data["beat7"])
