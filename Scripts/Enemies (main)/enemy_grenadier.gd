class_name Grenadier extends CharacterBody2D

@export var health: HealthComponent
@export var grenade_scene: PackedScene                 # assign grenade.tscn
@export var detection_range: float = 400.0             # Idle wakes up inside this
@export var min_distance: float = 160.0                # backs away if the player is closer than this
@export var max_distance: float = 240.0                # closes in if the player is farther than this
@export var throw_offset: Vector2 = Vector2(0, -6)     # where grenades leave the enemy

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)

func throw_grenade() -> void:
	if grenade_scene == null or not is_instance_valid(player):
		return

	var origin := global_position + throw_offset
	var target := player.global_position
	var g := get_gravity().y

	# Longer throws take longer, so far targets get a flatter arc, not a rocket
	var flight_time := clampf(origin.distance_to(target) / 260.0, 0.6, 1.4)

	# Solve for the launch velocity that lands on the target after flight_time:
	# x = vx*t   and   y = vy*t + 0.5*g*t^2
	var vel := Vector2(
		(target.x - origin.x) / flight_time,
		(target.y - origin.y) / flight_time - 0.5 * g * flight_time
	)

	var grenade: Grenade = grenade_scene.instantiate()
	get_tree().current_scene.add_child(grenade)
	grenade.global_position = origin
	grenade.launch(vel, self)

func _on_health_component_health_depleted() -> void:
	queue_free()
