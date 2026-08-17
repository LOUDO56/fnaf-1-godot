class_name Game extends Node2D

@export var office: Office
@export var animatronics: Animatronics

@onready var monitor_animation: MonitorAnimation = $"OfficeCamera/Switching Cameras/CanvasLayer2/Monitor"
@onready var office_camera: Camera2D = $"OfficeCamera"
@onready var jumpscare_timer := $"Jumpscare Timer"
@onready var jumpscare_sound := $"Animatronics/Default Jumpscare Audio"
@onready var success_screen: SuccessNightAnimation = preload("res://scenes/succeed_night_animation.tscn").instantiate()

func _ready() -> void:
	office.listen_flip_events(monitor_animation, office_camera)
	
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
	process_mode = Node.PROCESS_MODE_DISABLED
	success_screen.check_20_4(animatronics)
	get_tree().root.add_child(success_screen)

func _on_jumpscare_started(time: float, _animatronic: Animatronic) -> void:
	office.set_process(PROCESS_MODE_DISABLED)
	jumpscare_timer.start(time)
	_stop_audio()

func _on_power_off() -> void:
	jumpscare_timer.stop()
	_stop_audio()

func _stop_audio() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Ambiance"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), true)

func _on_jumpscare_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/death/death_statics.tscn")
	
