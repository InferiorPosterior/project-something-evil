class_name TurretYaw3D extends Node3D

@export var source_2d: Node2D                  # the turret's 2D node, e.g. ApcTurret (where the player is compared from)
@export var turn_speed_deg: float = 150.0      # how fast the head spins to face the other side
@export var deadzone_px: float = 8.0           # ignores tiny x differences so it doesn't flip-flop
@export var right_yaw_deg: float = 0.0         # yaw when facing right (barrel along +X)
@export var left_yaw_deg: float = 180.0        # yaw when facing left; use -180 to spin through the front instead

var player: Node2D
var facing_right: bool = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees.y = right_yaw_deg

func _process(delta: float) -> void:
	if is_instance_valid(player) and source_2d:
		var dx := player.global_position.x - source_2d.global_position.x
		if dx > deadzone_px:
			facing_right = true
		elif dx < -deadzone_px:
			facing_right = false

	var target := deg_to_rad(right_yaw_deg if facing_right else left_yaw_deg)
	rotation.y = rotate_toward(rotation.y, target, deg_to_rad(turn_speed_deg) * delta)
