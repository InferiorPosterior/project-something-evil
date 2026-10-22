class_name GrenadierThrow extends State

@export var windup: float = 0.6            # delay before the first throw
@export var throw_interval: float = 2.5    # seconds between throws
@export var exit_margin: float = 40.0      # extra room before it gives up the throwing stance

@onready var enemy: Grenadier = get_parent().get_parent()
var cooldown: float = 0.0

func enter_state() -> void:
	cooldown = windup
	enemy.velocity.x = 0

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)
	enemy.velocity.x = 0
	enemy.move_and_slide()

	if not enemy.is_on_floor():
		Transitioned.emit(self, "grenadierfall")
		return

	var dist := enemy.distance_to_player()

	# Wider band than the one that triggered the throw, so it doesn't flicker at the edges
	if dist < enemy.min_distance - exit_margin or dist > enemy.max_distance + exit_margin:
		Transitioned.emit(self, "grenadierreposition")
		return

	cooldown -= delta
	if cooldown <= 0.0:
		enemy.throw_grenade()
		cooldown = throw_interval
