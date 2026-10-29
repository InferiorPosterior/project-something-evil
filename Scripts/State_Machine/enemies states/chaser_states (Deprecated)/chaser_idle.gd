class_name ChaserIdle extends State

@onready var enemy: Chaser = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)
	enemy.velocity.x = 0
	enemy.move_and_slide()

	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) <= enemy.detection_range:
		Transitioned.emit(self, "chaserchase")
