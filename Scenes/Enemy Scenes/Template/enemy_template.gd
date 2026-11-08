class_name Enemy extends CharacterBody2D

@export var death_effect_scene: PackedScene
@export var death_sound: AudioStream

@export var health: HealthComponent
@export var detection_range: float = 300.0

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

func _on_health_component_health_depleted() -> void:
	if death_effect_scene:
		var effect = death_effect_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(effect)
		effect.global_position = global_position
		
	if death_sound:
		SoundManager.play_sound(death_sound,global_position)
	queue_free()
