class_name LungerRecover extends State

@export var recover_time: float = 0.8

@onready var lunger: Lunger = get_parent().get_parent()
var timer: float = 0.0

func enter_state() -> void:
	timer = recover_time
	lunger.dash_cooldown_left = lunger.dash_cooldown   # cooldown starts when the dash ends

func physics_update(delta: float) -> void:
	lunger.apply_gravity(delta)
	lunger.velocity.x = 0
	lunger.move_and_slide()

	if lunger.is_on_floor():            # if it ended the dash mid-air, it falls first, then the timer runs
		timer -= delta
		if timer <= 0.0:
			Transitioned.emit(self, "enemychase")
