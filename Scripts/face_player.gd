class_name FacePlayer extends Node2D

## Rotates this node to point at the player. Attach to any Node2D / Sprite2D.
@export var turn_speed: float = 0.0          ## rad/s, 0 = snap instantly
@export var angle_offset_degrees: float = 0.0 ## adjust if the sprite doesn't point right by default
@export var flip_when_facing_left: bool = true ## mirror vertically so the weapon isn't upside down

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	var target := (player.global_position - global_position).angle() + deg_to_rad(angle_offset_degrees)

	if turn_speed <= 0.0:
		global_rotation = target
	else:
		global_rotation = rotate_toward(global_rotation, target, turn_speed * delta)

	if flip_when_facing_left:
		var facing_left := absf(wrapf(global_rotation, -PI, PI)) > PI / 2.0
		scale.y = -absf(scale.y) if facing_left else absf(scale.y)
