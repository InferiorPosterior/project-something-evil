class_name MissilePod extends AmmoWeapon

@export var missile_scene: PackedScene         # apc_missile.tscn
@export var launch_speed: float = 160.0
@export var launch_spread: float = 35.0        # degrees either side of the pod's facing

func shoot() -> void:
	if missile_scene == null:
		push_warning("MissilePod: missile_scene is not assigned")
		return
	var missile = missile_scene.instantiate()
	missile.direction = Vector2.RIGHT.rotated(global_rotation + deg_to_rad(randf_range(-launch_spread, launch_spread)))
	missile.speed = launch_speed
	get_tree().current_scene.add_child(missile)
	missile.global_position = global_position
