class_name EnemyFall extends State

@export var air_speed: float = 60.0

@onready var enemy: Enemy = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta
	if is_instance_valid(enemy.player):
		var dx := enemy.player.global_position.x - enemy.global_position.x
		enemy.velocity.x = signf(dx) * air_speed if absf(dx) > 2.0 else 0.0
	enemy.move_and_slide()
	if enemy.is_on_floor():
		Transitioned.emit(self, "enemychase")
