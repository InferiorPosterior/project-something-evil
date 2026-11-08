class_name Enemy extends CharacterBody2D

@export var health: HealthComponent
@export var detection_range: float = 300.0
@export var death_effect: PackedScene                  # drag your death effect scene here, per enemy
@export var death_effect_offset: Vector2 = Vector2.ZERO   # nudge it if the enemy's origin isn't its centre

var player: Node2D

@export_enum(
	"Chaser",
	"Gunner",
	"Grenadier",
	"Drone",
	"Lunger",
	"Turret",
	"Brute",
	"Boss"
)
var enemy_score_type: String = "Chaser"

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	if health == null:
		health = get_node_or_null("HealthComponent") as HealthComponent

	if health == null:
		push_error(name + ": HealthComponent not found!")
		return

	if not health.health_depleted.is_connected(_on_health_component_health_depleted):
		health.health_depleted.connect(_on_health_component_health_depleted)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)

func spawn_death_effect() -> void:
	if death_effect == null:
		return
	var fx := death_effect.instantiate() as Node2D
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position + death_effect_offset   # set after add_child, because global_position needs the node in the tree

func _on_health_component_health_depleted() -> void:
	print("ENEMY NAME: ", name)
	print("ENEMY SCORE TYPE: ", enemy_score_type)

	ScoreManager.add_enemy_points(enemy_score_type)

	spawn_death_effect()
	queue_free()
