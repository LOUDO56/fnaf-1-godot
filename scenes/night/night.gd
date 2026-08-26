class_name Night extends Node2D

@onready var animatronics: Animatronics = get_tree().get_first_node_in_group("animatronics")
@onready var office: Office = get_tree().get_first_node_in_group("office")
@onready var monitor_animation: MonitorAnimation = $"OfficeCamera/Switching Cameras/CanvasLayer2/Monitor"
@onready var office_camera: Camera2D = $"OfficeCamera"
@onready var jumpscare_timer := $"Jumpscare Timer"
@onready var jumpscare_sound := $"Animatronics/Default Jumpscare Audio"
@onready var success_screen: SuccessNightAnimation = preload("res://scenes/6_am/6_am.tscn").instantiate()

func _ready() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Ambiance"), false)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), false)
	
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)
	
	animatronics.bonnie.animatronic_moved.connect(animatronics.freddy.on_bonnie_move)
	animatronics.chica.animatronic_moved.connect(animatronics.freddy.on_chica_move)
	
	Events.jumpscare_started.connect(_on_jumpscare_started)
	Events.power_off.connect(_on_power_off)
	
func _on_monitor_opened() -> void:
	office_camera.set_process(false)
	
func _on_monitor_closed(_last_camera_viewed: CameraMap.Camera) -> void:
	office_camera.set_process(true)
	
func success_night():
	add_child(success_screen)
	process_mode = Node.PROCESS_MODE_DISABLED
	success_screen.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_jumpscare_started(time: float, _animatronic: Animatronic) -> void:
	office.process_mode = Node.PROCESS_MODE_DISABLED
	jumpscare_timer.start(time)
	_stop_audio()

func _on_power_off() -> void:
	jumpscare_timer.stop()
	_stop_audio()

func _stop_audio() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Ambiance"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), true)

func _on_jumpscare_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over/death_statics/death_statics.tscn")
	
