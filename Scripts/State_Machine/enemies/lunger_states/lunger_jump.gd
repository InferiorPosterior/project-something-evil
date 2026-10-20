class_name LungerJump extends State

@export var jump_velocity: float = -500.0
@export var air_speed: float = 40.0

@onready var lunger: Lunger = get_parent().get_parent()

func enter_state() -> void:
	lunger.velocity.y = jump_velocity

func physics_update(delta: float) -> void:
	lunger.velocity += lunger.get_gravity() * delta

	if is_instance_valid(lunger.player):
		lunger.velocity.x = signf(lunger.player.global_position.x - lunger.global_position.x) * air_speed

	lunger.move_and_slide()

	if lunger.velocity.y >= 0:
		Transitioned.emit(self, "lungerfall")
