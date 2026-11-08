class_name Gunner extends Enemy

@export var projectile_scene: PackedScene
@export var shoot_enter_range: float = 120.0       # Chase -> Shoot when closer than this
@export var shoot_exit_range: float = 220.0        # Shoot -> Chase only when farther than this
@export var muzzle_offset: Vector2 = Vector2(0, 4) # where bullets spawn, relative to the enemy

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _process(_delta: float) -> void:
	if absf(velocity.x) > 1.0:
		$AnimatedSprite2D.flip_h = velocity.x < 0.0

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF   # no player = "infinitely far", so states fall back to Idle
	return global_position.distance_to(player.global_position)
