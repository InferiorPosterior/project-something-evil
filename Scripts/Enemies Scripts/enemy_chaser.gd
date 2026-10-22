# THIS IS ENEMY SCRIPT
class_name Chaser extends CharacterBody2D

@export var health: HealthComponent
@export var detection_range: float = 300.0

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_health_component_health_depleted() -> void:
	queue_free()
