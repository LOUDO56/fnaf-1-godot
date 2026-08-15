extends Node2D

@export var office: Office
@export var animatronics: Animatronics

@onready var doors: Doors = $"Office/Doors"
@onready var monitor_animation: MonitorAnimation = $"OfficeCamera/Watching Cameras/CanvasLayer/Monitor"
@onready var office_camera: Camera2D = $"OfficeCamera"
@onready var jumpscare_timer := $"Jumpscare Timer"
@onready var death_layer := $"Death Layer"
@onready var jumpscare_sound := $"Office/Animatronics/Default Jumpscare Audio"

func _ready() -> void:
	doors.setup_animatronics_behavior(animatronics)
	office.listen_flip_events(monitor_animation, office_camera)
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)
	Events.jumpscare_started.connect(_on_jumpscare_started)
	
func _on_monitor_opened() -> void:
	office_camera.set_process(false)
	
func _on_monitor_closed() -> void:
	office_camera.set_process(true)

func _on_jumpscare_started(time: float) -> void:
	Globals.state = Globals.State.DIED
	office.set_process(PROCESS_MODE_DISABLED)
	jumpscare_timer.start(time)
	for ambiance_sound in get_tree().get_nodes_in_group("ambiance"):
		ambiance_sound.stop()

func _on_jumpscare_timer_timeout() -> void:
	death_layer.show_death_statics()
	jumpscare_sound.stop()
	
