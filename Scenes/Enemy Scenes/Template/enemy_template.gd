class_name Enemy extends CharacterBody2D

@export var health: HealthComponent
@export var detection_range: float = 300.0
@export var death_effect: PackedScene                  # drag your death effect scene here, per enemy
@export var death_effect_offset: Vector2 = Vector2.ZERO   # nudge it if the enemy's origin isn't its centre

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

func spawn_death_effect() -> void:
	if death_effect == null:
		return
	var fx := death_effect.instantiate() as Node2D
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position + death_effect_offset   # set after add_child, because global_position needs the node in the tree

func _on_health_component_health_depleted() -> void:
	spawn_death_effect()
	queue_free()
