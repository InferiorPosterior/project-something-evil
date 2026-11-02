class_name Apc extends Enemy

@export var same_level_tolerance: float = 24.0   # |player.y - apc.y| under this counts as "same level"

var facing: float = 1.0
var ram_cooldown_left: float = 0.0

func _ready() -> void:
	super()
	if player is PhysicsBody2D:
		add_collision_exception_with(player)     # the ram carries through you instead of being blocked

func _physics_process(delta: float) -> void:
	ram_cooldown_left = maxf(ram_cooldown_left - delta, 0.0)

func face_player() -> void:
	if is_instance_valid(player):
		var dx := player.global_position.x - global_position.x
		if absf(dx) > 2.0:
			facing = signf(dx)

func is_player_on_same_level() -> bool:
	return is_instance_valid(player) and absf(player.global_position.y - global_position.y) <= same_level_tolerance

func _on_health_component_health_depleted() -> void:
	queue_free()

func _on_hurtbox_component_damage_taken(damage: int) -> void:
	print($HealthComponent.current_health)
