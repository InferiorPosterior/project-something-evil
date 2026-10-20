class_name GunnerIdle extends State

@onready var enemy: Gunner = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)
	enemy.velocity.x = 0
	enemy.move_and_slide()

	if enemy.distance_to_player() <= enemy.detection_range:
		Transitioned.emit(self, "gunnerchase")
