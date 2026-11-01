class_name Autocannon extends AmmoWeapon

@export var bullet_scene: PackedScene          # apc_bullet.tscn
@export var bullet_speed: float = 260.0
@export var spread_degrees: float = 4.0
@export var muzzle_distance: float = 20.0

func shoot() -> void:
	if bullet_scene == null:
		push_warning("Autocannon: bullet_scene is not assigned")
		return
	var angle := global_rotation + deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	var bullet = bullet_scene.instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle)
	bullet.speed = bullet_speed
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position + Vector2.RIGHT.rotated(global_rotation) * muzzle_distance
