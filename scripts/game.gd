extends Node2D

@export var office: Office
@export var animatronics: Animatronics

@onready var doors: Doors = $"Office/Doors"
@onready var monitor_animation: MonitorAnimation = $"OfficeCamera/Switching Cameras/CanvasLayer2/Monitor"
@onready var office_camera: Camera2D = $"OfficeCamera"
@onready var jumpscare_timer := $"Jumpscare Timer"
@onready var death_layer := $"Death Layer"
@onready var jumpscare_sound := $"Office/Animatronics/Default Jumpscare Audio"

func _ready() -> void:
	doors.setup_animatronics_behavior(animatronics)
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

func _on_jumpscare_started(time: float, animatronic: Animatronic) -> void:
	Globals.state = Globals.State.DIED
	office.set_process(PROCESS_MODE_DISABLED)
	jumpscare_timer.start(time)
	_stop_audio()

func _on_power_off() -> void:
	jumpscare_timer.stop()
	_stop_audio()

func _stop_audio() -> void:
	for ambiance_sound in get_tree().get_nodes_in_group("ambiance"):
		ambiance_sound.stop()

func _on_jumpscare_timer_timeout() -> void:
	death_layer.show_death_statics()
	jumpscare_sound.stop()
	
