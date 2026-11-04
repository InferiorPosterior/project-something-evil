# THIS IS THE GUN SCRIPT
extends Node2D

@export var shoot_sound: AudioStream

@export var PROJECTILE: PackedScene
@export var fire_rate: float = 4.0            # shots per second while holding the button
@export var orbit_radius: float = 8.0         # distance from the pivot to the gun
@export var pivot_offset: Vector2 = Vector2(0, 4)   # pivot relative to the player (chest height)

@onready var muzzle: Marker2D = $Marker2D
@onready var player: Node2D = get_parent()

var cooldown_left: float = 0.0

func _process(delta: float) -> void:
	# Orbit: sit on a circle around the pivot, pointing at the cursor
	var pivot := player.global_position + pivot_offset
	var dir := (get_global_mouse_position() - pivot).normalized()
	global_position = pivot + dir * orbit_radius
	rotation = dir.angle()
	scale.y = -1.0 if dir.x < 0.0 else 1.0    # keep the gun right-side up when aiming left

	# Count the cooldown down every frame
	cooldown_left = maxf(cooldown_left - delta, 0.0)

	#Fire while the button is held, as long as the cooldown has finished
	if Input.is_action_pressed("use_item") and cooldown_left <= 0.0:
		shoot()
		cooldown_left = 1.0 / fire_rate

func shoot() -> void:
	SoundManager.play_sound(shoot_sound, global_position)
	var projectile_instance = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.global_position = muzzle.global_position
	projectile_instance.rotation = rotation
