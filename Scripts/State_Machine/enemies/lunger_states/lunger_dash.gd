class_name LungerDash extends State

@export var dash_speed: float = 500.0
@export var dash_distance: float = 200.0   # keep this larger than dash_range so it overshoots the target

@onready var lunger: Lunger = get_parent().get_parent()
var traveled: float = 0.0

func enter_state() -> void:
	traveled = 0.0

func exit_state() -> void:
	lunger.velocity = Vector2.ZERO              # stop dead; Recover handles gravity

func physics_update(delta: float) -> void:
	lunger.velocity = lunger.dash_direction * dash_speed
	lunger.move_and_slide()

	traveled += lunger.get_position_delta().length()

	if traveled >= dash_distance or lunger.is_on_wall() or lunger.is_on_ceiling():
		Transitioned.emit(self, "lungerrecover")
