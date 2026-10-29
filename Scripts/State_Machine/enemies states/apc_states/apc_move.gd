class_name ApcMove extends State

@export var max_speed: float = 60.0
@export var accel: float = 80.0               # speeding up is gradual...
@export var decel: float = 160.0              # ...and stopping is quicker
@export var close_in_distance: float = 260.0  # beyond this horizontal distance it drives toward you
@export var ram_max_distance: float = 500.0   # won't ram from farther away than this

@onready var apc: Apc = get_parent().get_parent()

func physics_update(delta: float) -> void:
	apc.apply_gravity(delta)

	if not is_instance_valid(apc.player):
		apc.velocity.x = move_toward(apc.velocity.x, 0.0, decel * delta)
		apc.move_and_slide()
		return

	apc.face_player()
	var dx := apc.player.global_position.x - apc.global_position.x

	if apc.ram_cooldown_left <= 0.0 and apc.is_player_on_same_level() and absf(dx) <= ram_max_distance:
		Transitioned.emit(self, "apcram")
		return

	if absf(dx) > close_in_distance:
		apc.velocity.x = move_toward(apc.velocity.x, apc.facing * max_speed, accel * delta)
	else:
		apc.velocity.x = move_toward(apc.velocity.x, 0.0, decel * delta)
	apc.move_and_slide()
