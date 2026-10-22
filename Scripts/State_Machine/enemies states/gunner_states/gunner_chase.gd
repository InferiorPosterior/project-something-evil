class_name GunnerChase extends State

@export var speed: float = 100.0
@export var lose_range_multiplier: float = 1.5

@onready var enemy: Gunner = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)

	if not enemy.is_on_floor():
		Transitioned.emit(self, "gunnerfall")
		return

	var dist := enemy.distance_to_player()

	if dist > enemy.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "gunneridle")
		return

	if dist <= enemy.shoot_enter_range:       # close enough: stop and shoot
		Transitioned.emit(self, "gunnershoot")
		return

	var dx := enemy.player.global_position.x - enemy.global_position.x
	enemy.velocity.x = signf(dx) * speed if absf(dx) > 2.0 else 0.0   # 2px deadzone stops jitter
	enemy.move_and_slide()
