class_name ChaserFall extends State

@export var air_speed: float = 60.0

@onready var enemy: Chaser = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta

	if enemy.player:
		enemy.velocity.x = signf(enemy.player.global_position.x - enemy.global_position.x) * air_speed

	enemy.move_and_slide()

	if enemy.is_on_floor():
		Transitioned.emit(self, "chaserchase")
