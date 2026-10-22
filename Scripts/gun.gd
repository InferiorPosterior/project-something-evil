# THIS IS THE GUN SCRIPT
extends Node2D

const PROJECTILE = preload("res://Scenes/Projectiles & Hazards/projectile.tscn")

@onready var muzzle: Marker2D = $Marker2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	#Keep rotation degrees between 0 and 360, flip sprite when facing opposite direction
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	#Fire when player uses gun
	if Input.is_action_just_pressed("use_item"):
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = muzzle.global_position
		projectile_instance.rotation = rotation
