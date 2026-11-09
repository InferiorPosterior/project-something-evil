class_name Enemy extends CharacterBody2D

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


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _on_hurtbox_component_damage_taken(damage: int) -> void:
	sprite.self_modulate = Color(4.567, 4.567, 4.567, 1.0)
	await  get_tree().create_timer(0.1).timeout
	
	if is_instance_valid(sprite):
		sprite.self_modulate = Color.WHITE
	
