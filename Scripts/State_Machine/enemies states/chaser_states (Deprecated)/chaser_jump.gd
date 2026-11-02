class_name ChaserJump extends State

@export var jump_velocity: float = -400.0
@export var air_speed: float = 60.0

@onready var enemy: Chaser = get_parent().get_parent()

func enter_state() -> void:
	enemy.velocity.y = jump_velocity

func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta

	if enemy.player:
		enemy.velocity.x = signf(enemy.player.global_position.x - enemy.global_position.x) * air_speed

	enemy.move_and_slide()

	if enemy.velocity.y >= 0:
		Transitioned.emit(self, "chaserfall")
