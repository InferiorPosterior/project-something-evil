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
	# 1. Disable collisions and input so the dead enemy stops interacting with the world
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	# 2. Wait for exactly 0.05 seconds
	await get_tree().create_timer(0.05).timeout

	if death_effect_scene:
		var effect = death_effect_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(effect)
		effect.global_position = global_position
		
	if death_sound:
		SoundManager.play_sound(death_sound,global_position)
	queue_free()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _on_hurtbox_component_damage_taken(damage: int) -> void:
	sprite.self_modulate = Color(4.567, 4.567, 4.567, 1.0)
	await  get_tree().create_timer(0.1).timeout
	
	if is_instance_valid(sprite):
		sprite.self_modulate = Color.WHITE
	
