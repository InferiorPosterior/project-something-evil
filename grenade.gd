class_name Grenade extends RigidBody2D

@export var explosion_scene: PackedScene     # assign explosion.tscn
@export var fuse_time: float = 2.5           # seconds it lingers after landing before exploding
@export var max_lifetime: float = 6.0        # safety net: explodes even if it never lands

var fuse_left: float = -1.0                  # -1 means the fuse isn't lit yet
var exploded: bool = false

func _ready() -> void:
	contact_monitor = true                   # required for body_entered on a RigidBody2D
	max_contacts_reported = 4
	# Replace the project's default damping so the throw arc matches the maths exactly
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp = 0.0
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(max_lifetime).timeout.connect(explode)

func launch(vel: Vector2, thrower: PhysicsBody2D) -> void:
	linear_velocity = vel
	add_collision_exception_with(thrower)    # so it can't blow up on the enemy that threw it

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:              # the player or another enemy: explode immediately
		explode.call_deferred()              # deferred: can't spawn physics nodes mid-collision callback
	elif fuse_left < 0.0:                    # first touch of the world lights the fuse
		fuse_left = fuse_time
		linear_damp = 2.0                    # stop it rolling and bouncing forever
		angular_damp = 4.0

func _physics_process(delta: float) -> void:
	if fuse_left >= 0.0:
		fuse_left -= delta
		if fuse_left <= 0.0:
			explode()

func _process(_delta: float) -> void:
	if fuse_left >= 0.0:
		# blink faster as the fuse runs down
		var rate := lerpf(3.0, 10.0, 1.0 - fuse_left / fuse_time)
		var on := sin(Time.get_ticks_msec() * 0.001 * rate * TAU) > 0.0
		modulate = Color(1.0, 0.4, 0.4) if on else Color.WHITE

func explode() -> void:
	if exploded:
		return
	exploded = true
	if explosion_scene:
		var fx := explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		fx.global_position = global_position
	queue_free()
