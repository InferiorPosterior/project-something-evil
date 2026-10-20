class_name LungerChase extends State

@export var speed: float = 40.0
@export var elevation_threshold: float = 24.0
@export var jump_horizontal_range: float = 80.0
@export var lose_range_multiplier: float = 1.5

@onready var lunger: Lunger = get_parent().get_parent()

func physics_update(delta: float) -> void:
	lunger.apply_gravity(delta)

	if not lunger.is_on_floor():
		Transitioned.emit(self, "lungerfall")
		return
	if not is_instance_valid(lunger.player):
		Transitioned.emit(self, "lungeridle")
		return

	var to_player := lunger.player.global_position - lunger.global_position

	if to_player.length() > lunger.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "lungeridle")
		return

	# Dash: grounded, off cooldown, player in range
	if lunger.dash_cooldown_left <= 0.0 and to_player.length() <= lunger.dash_range:
		Transitioned.emit(self, "lungerwindup")
		return

	# Jump up to platforms (negative y = player is higher)
	if to_player.y < -elevation_threshold and absf(to_player.x) < jump_horizontal_range:
		Transitioned.emit(self, "lungerjump")
		return

	# 2px deadzone stops left-right twitching when directly below the player
	lunger.velocity.x = signf(to_player.x) * speed if absf(to_player.x) > 2.0 else 0.0
	lunger.move_and_slide()
