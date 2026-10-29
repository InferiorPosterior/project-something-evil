class_name Lunger extends Enemy

@export var sprite: CanvasItem                 # optional, tinted during windup
@export var dash_range: float = 130.0          # dash starts when the player is closer than this
@export var dash_cooldown: float = 2.0         # seconds after a dash before the next one is allowed

var dash_cooldown_left: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO     # locked in by the windup state

func _ready() -> void:
	super()                                    # runs Chaser's _ready (finds the player)
	if is_instance_valid(player) and player is PhysicsBody2D:
		add_collision_exception_with(player)   # pass through the player's body; damage comes from hitbox/hurtbox only

func _physics_process(delta: float) -> void:
	dash_cooldown_left = maxf(dash_cooldown_left - delta, 0.0)

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)
