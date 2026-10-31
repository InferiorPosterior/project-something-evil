class_name EnemyJump extends State

@export var jump_velocity: float = -300.0
@export var air_speed: float = 60.0

@onready var enemy: Enemy = get_parent().get_parent()

func enter_state() -> void:
	enemy.velocity.y = jump_velocity
	enemy.get_node("AnimatedSprite2D").play("fall")


func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta
	if is_instance_valid(enemy.player):
		var dx := enemy.player.global_position.x - enemy.global_position.x
		enemy.velocity.x = signf(dx) * air_speed if absf(dx) > 2.0 else 0.0
	enemy.move_and_slide()
	if enemy.velocity.y >= 0:
		Transitioned.emit(self, "enemyfall")
