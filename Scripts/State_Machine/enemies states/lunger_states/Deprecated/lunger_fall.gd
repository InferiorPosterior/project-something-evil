class_name LungerFall extends State

@export var air_speed: float = 40.0

@onready var lunger: Lunger = get_parent().get_parent()

func physics_update(delta: float) -> void:
	lunger.velocity += lunger.get_gravity() * delta

	if is_instance_valid(lunger.player):
		lunger.velocity.x = signf(lunger.player.global_position.x - lunger.global_position.x) * air_speed

	lunger.move_and_slide()

	if lunger.is_on_floor():
		Transitioned.emit(self, "lungerchase")
