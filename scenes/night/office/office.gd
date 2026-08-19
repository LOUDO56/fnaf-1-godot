class_name Office extends Node2D

@onready var fan_audio = $"Fan/Fan Audio"
@onready var fan = $"Fan"
@onready var left_door: LeftDoor = $"Doors/Left/LeftDoorButtons"
@onready var right_door: RightDoor = $"Doors/Right/RightDoorButtons"
@onready var office_stage: OfficeStage = $"Stage"
@onready var power_off_audio := $"Ambiance/Power Off Audio"
@onready var monitor_animation: MonitorAnimation = get_tree().get_first_node_in_group("monitor")
@onready var office_camera: Camera2D = get_tree().get_first_node_in_group("office_camera")

func _ready() -> void:
	Events.power_off.connect(_on_power_off)
	Events.jumpscare_started.connect(_on_jumpscare_started)
	monitor_animation.monitor_opened.connect(_on_monitor_opened)
	monitor_animation.monitor_closed.connect(_on_monitor_closed)

func _on_monitor_opened():
	visible = false
	fan_audio.volume_db -= 10
	left_door.turn_off_light()
	right_door.turn_off_light()
	
func hide_doors():
	left_door.visible = false
	right_door.visible = false

func _on_monitor_closed(_last_camera_viewed: CameraMap.Camera):
	office_camera.make_current()
	visible = true
	fan_audio.volume_db += 10

func _on_power_off():
	power_off_audio.play()
	fan.visible = false
	fan.stop()


func _on_jumpscare_started(_time: float, animatronic: Animatronic):
	if animatronic is Foxy:
		return
	fan.visible = false
	fan.stop()
