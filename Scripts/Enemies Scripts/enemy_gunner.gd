class_name Gunner extends CharacterBody2D

@export var health: HealthComponent
@export var projectile_scene: PackedScene
@export var detection_range: float = 300.0         # Idle wakes up inside this
@export var shoot_enter_range: float = 120.0       # Chase -> Shoot when closer than this
@export var shoot_exit_range: float = 220.0        # Shoot -> Chase only when farther than this
@export var muzzle_offset: Vector2 = Vector2(0, 4) # where bullets spawn, relative to the enemy

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF   # no player = "infinitely far", so states fall back to Idle
	return global_position.distance_to(player.global_position)

func _on_health_component_health_depleted() -> void:
	queue_free()
