class_name DroneIdle extends State

@export var bob_amplitude: float = 10.0   # vertical hover wobble (px/s of velocity)
@export var bob_speed: float = 2.0
@export var drag: float = 300.0           # how fast it settles into hovering

@onready var drone: Drone = get_parent().get_parent()
var time: float = 0.0

func physics_update(delta: float) -> void:
	time += delta
	var bob := Vector2(0.0, sin(time * bob_speed) * bob_amplitude)
	drone.velocity = drone.velocity.move_toward(bob, drag * delta)   # glide to a hover, then bob
	drone.move_and_slide()

	if drone.distance_to_player() <= drone.detection_range:
		Transitioned.emit(self, "dronechase")
