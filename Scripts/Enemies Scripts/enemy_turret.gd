class_name Turret extends Node2D

@export var projectile_scene: PackedScene      # set once in turret.tscn
@export var sight_range: float = 280.0
@export var burst_count: int = 3
@export var shot_delay: float = 0.15           # seconds between shots in a burst
@export var burst_cooldown: float = 2.5        # seconds between bursts

var player: Node2D
var shots_left: int = 0
var shot_timer: float = 0.0
var cooldown_left: float = 1.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	if shots_left > 0:                          # mid-burst
		shot_timer -= delta
		if shot_timer <= 0.0:
			fire()
			shots_left -= 1
			shot_timer = shot_delay
			if shots_left == 0:
				cooldown_left = burst_cooldown
	else:                                       # waiting for the next burst
		cooldown_left -= delta
		if cooldown_left <= 0.0 and can_see_player():
			shots_left = burst_count
			shot_timer = 0.0                    # first shot comes out immediately

func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) > sight_range:
		return false
	# Ray against the world (layer 1). It sees the player unless a wall is in the way.
	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1)
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.collider == player

func fire() -> void:
	if projectile_scene == null:
		push_warning("Turret: projectile_scene is not assigned")
		return
	var bullet = projectile_scene.instantiate()
	bullet.direction = (player.global_position - global_position).normalized()   # aims at the player's current position
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position

func _on_health_component_health_depleted() -> void:
	queue_free()
