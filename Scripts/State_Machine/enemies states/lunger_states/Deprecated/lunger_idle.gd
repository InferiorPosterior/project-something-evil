class_name LungerIdle extends State

@onready var lunger: Lunger = get_parent().get_parent()

func physics_update(delta: float) -> void:
	lunger.apply_gravity(delta)
	lunger.velocity.x = 0
	lunger.move_and_slide()

	if lunger.distance_to_player() <= lunger.detection_range:
		Transitioned.emit(self, "lungerchase")
