class_name ChaserChase extends State

@export var speed: float = 175.0
@export var elevation_threshold: float = 24.0
@export var jump_horizontal_range: float = 100.0
@export var lose_range_multiplier: float = 1.5

@onready var enemy: Chaser = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)

	if not enemy.is_on_floor():
		Transitioned.emit(self, "chaserfall")
		return
	if not enemy.player:
		Transitioned.emit(self, "chaseridle")
		return

	var to_player := enemy.player.global_position - enemy.global_position

	if to_player.length() > enemy.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "chaseridle")
		return

	# negative y = player is higher up
	if to_player.y < -elevation_threshold and absf(to_player.x) < jump_horizontal_range:
		Transitioned.emit(self, "chaserjump")
		return

	enemy.velocity.x = signf(to_player.x) * speed
	enemy.move_and_slide()
