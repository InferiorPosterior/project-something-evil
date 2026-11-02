class_name EnemyChase extends State

@export var speed: float = 100.0
@export var can_jump: bool = true                # turn off for enemies that never jump
@export var elevation_threshold: float = 24.0
@export var jump_horizontal_range: float = 100.0
@export var lose_range_multiplier: float = 1.5

@onready var enemy: Enemy = get_parent().get_parent()

# Subclasses override this to add an enemy-specific transition.
# Return the name of the state to switch to, or "" for none.
func special_transition(_to_player: Vector2) -> String:
	return ""

func enter_state() -> void:
	enemy.get_node("AnimatedSprite2D").play("chase")

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)

	if not enemy.is_on_floor():
		Transitioned.emit(self, "enemyfall")
		return
	if not is_instance_valid(enemy.player):
		Transitioned.emit(self, "enemyidle")
		return

	var to_player := enemy.player.global_position - enemy.global_position

	if to_player.length() > enemy.detection_range * lose_range_multiplier:
		Transitioned.emit(self, "enemyidle")
		return

	var special := special_transition(to_player)
	if special != "":
		Transitioned.emit(self, special)
		return

	# negative y = player is higher up
	if can_jump and to_player.y < -elevation_threshold and absf(to_player.x) < jump_horizontal_range:
		Transitioned.emit(self, "enemyjump")
		return

	# 2px deadzone stops left-right twitching when directly below the player
	enemy.velocity.x = signf(to_player.x) * speed if absf(to_player.x) > 2.0 else 0.0
	enemy.move_and_slide()
