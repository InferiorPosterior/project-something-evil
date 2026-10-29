class_name DroneChase extends State

@export_group("Flight")
@export var max_speed: float = 300.0
@export var acceleration: float = 140.0       # px/s² gained while facing the player
@export var turn_brake: float = 320.0         # px/s² lost while facing away from the player
@export var fast_turn_rate: float = 3.0       # rad/s at top speed (wide arcs)
@export var slow_turn_rate: float = 7.0       # rad/s when nearly stopped (tight turns)
@export var lose_range_multiplier: float = 1.5

@export_group("Bounce")
@export var bounce_strength: float = 0.7      # rebound speed = impact speed * this
@export var bounce_drag: float = 220.0        # px/s² slowing the rebound; lower = bounces farther
@export var min_bounce_impact: float = 25.0   # slower hits just scrape along the wall
@export var regain_control_speed: float = 40.0
@export var max_bounce_time: float = 1.5      # safety limit on losing control

@onready var drone: Drone = get_parent().get_parent()

var heading: Vector2 = Vector2.RIGHT
var speed: float = 0.0
var bouncing: bool = false
var bounce_left: float = 0.0

func enter_state() -> void:
	bouncing = false
	speed = drone.velocity.length()
	if speed > 1.0:
		heading = drone.velocity / speed             # keep the direction it was already drifting
	elif is_instance_valid(drone.player):
		heading = (drone.player.global_position - drone.global_position).normalized()

func physics_update(delta: float) -> void:
	if not is_instance_valid(drone.player) \
			or drone.distance_to_player() > drone.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "droneidle")
		return

	if bouncing:
		bounce_left -= delta
		speed = move_toward(speed, 0.0, bounce_drag * delta)   # no steering while rebounding
		if speed <= regain_control_speed or bounce_left <= 0.0:
			bouncing = false
	else:
		_home_in(delta)

	var impact_velocity := heading * speed
	drone.velocity = impact_velocity
	drone.move_and_slide()

	if drone.get_slide_collision_count() > 0:
		var normal := drone.get_last_slide_collision().get_normal()
		if impact_velocity.dot(normal) < -min_bounce_impact:    # moving into the surface fast enough
			var rebound := impact_velocity.bounce(normal) * bounce_strength
			heading = rebound.normalized()
			speed = rebound.length()
			bouncing = true
			bounce_left = max_bounce_time

func _home_in(delta: float) -> void:
	var to_player := drone.player.global_position - drone.global_position
	if to_player.length() < 1.0:
		return
	var desired := to_player.normalized()

	# Turn rate depends on speed: fast = wide arcs (overshoots you), slow = tight turns
	var speed_ratio := clampf(speed / max_speed, 0.0, 1.0)
	var turn_rate := lerpf(slow_turn_rate, fast_turn_rate, speed_ratio)
	var step := clampf(heading.angle_to(desired), -turn_rate * delta, turn_rate * delta)
	heading = heading.rotated(step)

	# alignment: 1 = flying straight at the player, -1 = flying directly away
	var alignment := heading.dot(desired)
	if alignment > 0.0:
		speed = move_toward(speed, max_speed, acceleration * alignment * delta)
	else:
		speed = move_toward(speed, 0.0, turn_brake * -alignment * delta)
