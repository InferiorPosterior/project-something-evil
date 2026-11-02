class_name WeaponPitch3D extends Node3D

@export var weapon_2d: Node2D                  # the 2D weapon this mirrors (Autocannon or MissilePod)
@export var min_pitch_deg: float = -20.0
@export var max_pitch_deg: float = 70.0
@export var smoothing: float = 20.0            # higher = follows the 2D aim more tightly; 0 = snap exactly

func _process(delta: float) -> void:
	if weapon_2d == null:
		return

	var aim := Vector2.RIGHT.rotated(weapon_2d.global_rotation)   # the weapon's 2D aim direction (y points down)
	var elevation := atan2(-aim.y, absf(aim.x))                    # positive = barrel above horizontal
	var target := clampf(elevation, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))

	if smoothing <= 0.0:
		rotation.x = target
	else:
		# Fixed both the typo (reading from .y) and changed the axis to .x
		rotation.x = lerp_angle(rotation.x, target, 1.0 - exp(-smoothing * delta))
