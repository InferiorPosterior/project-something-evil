class_name GrenadierReposition extends State

@export var speed: float = 50.0
@export var lose_range_multiplier: float = 1.5

@onready var enemy: Grenadier = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)

	if not enemy.is_on_floor():
		Transitioned.emit(self, "grenadierfall")
		return

	var dist := enemy.distance_to_player()

	if dist > enemy.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "grenadieridle")
		return

	var dir := signf(enemy.player.global_position.x - enemy.global_position.x)

	if dist < enemy.min_distance:                 # too close: back away
		enemy.velocity.x = -dir * speed
		enemy.move_and_slide()
		if enemy.is_on_wall():                    # cornered: stop running and throw anyway
			Transitioned.emit(self, "grenadierfire")
	elif dist > enemy.max_distance:               # too far: close in
		enemy.velocity.x = dir * speed
		enemy.move_and_slide()
	else:                                         # in the sweet spot
		Transitioned.emit(self, "grenadierfire")
