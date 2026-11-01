# THIS IS THE GUN SCRIPT
extends Node2D

@export var PROJECTILE: PackedScene
@export var fire_rate: float = 4.0          # shots per second while holding the button

@onready var muzzle: Marker2D = $Marker2D

var cooldown_left: float = 0.0

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

	#Keep rotation degrees between 0 and 360, flip sprite when facing opposite direction
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

	#Count the cooldown down every frame
	cooldown_left = maxf(cooldown_left - delta, 0.0)

	#Fire while the button is held, as long as the cooldown has finished
	if Input.is_action_pressed("use_item") and cooldown_left <= 0.0:
		$AudioStreamPlayer.play()
		shoot()
		cooldown_left = 1.0 / fire_rate

func shoot() -> void:
	var projectile_instance = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.global_position = muzzle.global_position
	projectile_instance.rotation = rotation
