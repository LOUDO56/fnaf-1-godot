extends Node

var night := 1
var star := 0
var played_phone_guy_voice: Array[AudioStreamPlayer]

var night_7_ai_level = {
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
		"night": PlayerData.night,
		"star": self.star
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

		night = int(json.data["night"])
		star = int(json.data["star"])
