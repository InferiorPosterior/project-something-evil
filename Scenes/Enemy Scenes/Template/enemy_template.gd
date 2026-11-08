class_name Enemy extends CharacterBody2D

@export var death_effect_scene: PackedScene
@export var death_sound: AudioStream

@export var health: HealthComponent
@export var detection_range: float = 300.0

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

func _on_health_component_health_depleted() -> void:
	if death_effect_scene:
		var effect = death_effect_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(effect)
		effect.global_position = global_position
		
	if death_sound:
		SoundManager.play_sound(death_sound,global_position)
	queue_free()
