class_name LungerDash extends State

@export var dash_distance: float = 200.0
@export var duration: float = 0.35
@export var ease_power: float = 2.0     # 1 = even slowdown, 2-3 = hard burst then a glide to a stop

@onready var lunger: Lunger = get_parent().get_parent()

var elapsed: float = 0.0
var launch_speed: float = 0.0

func enter_state() -> void:
	elapsed = 0.0
	# Chosen so the total distance travelled equals dash_distance:
	# the area under speed = launch_speed * (1 - t)^power over the duration.
	launch_speed = dash_distance * (ease_power + 1.0) / duration

func exit_state() -> void:
	lunger.velocity = Vector2.ZERO              # Recover applies gravity from here

func physics_update(delta: float) -> void:
	elapsed += delta
	var t := clampf(elapsed / duration, 0.0, 1.0)

	# Fast at the start, easing to zero at the end. Direction never changes, so it stays a straight line.
	var speed := launch_speed * pow(1.0 - t, ease_power)
	lunger.velocity = lunger.dash_direction * speed
	lunger.move_and_slide()

	if t >= 1.0 or lunger.is_on_wall() or lunger.is_on_ceiling():
		Transitioned.emit(self, "lungerrecover")
