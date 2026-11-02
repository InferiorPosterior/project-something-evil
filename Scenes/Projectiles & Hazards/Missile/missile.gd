extends Area2D

@export var burst_scene: PackedScene           # enemy_projectile.tscn
@export var explosion_scene: PackedScene       # optional visual and blast
@export var burst_count: int = 12
@export var burst_speed: float = 140.0
@export var turn_speed_deg: float = 80.0       # steering rate toward the player
@export var homing_time: float = 3.0           # stops steering after this long, so it can be outrun
@export var lifetime: float = 6.0

var direction: Vector2 = Vector2.UP            # set by the pod before it's added
var speed: float = 160.0
var player: Node2D
var age: float = 0.0
var exploded: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rotation = direction.angle()
	body_entered.connect(func(_body): explode.call_deferred())
	get_tree().create_timer(lifetime).timeout.connect(explode)

func _physics_process(delta: float) -> void:
	age += delta
	if age < homing_time and is_instance_valid(player):
		var step := deg_to_rad(turn_speed_deg) * delta
		var diff := angle_difference(direction.angle(), (player.global_position - global_position).angle())
		direction = direction.rotated(clampf(diff, -step, step))
		rotation = direction.angle()
	global_position += direction * speed * delta

func explode() -> void:
	if exploded:
		return
	exploded = true

	# Back off slightly so the ring doesn't spawn inside the wall it just hit
	var origin := global_position - direction * 6.0
	for i in burst_count:                       # evenly spaced circle
		var bullet = burst_scene.instantiate()
		bullet.direction = Vector2.RIGHT.rotated(TAU * i / burst_count)
		bullet.speed = burst_speed
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = origin

	if explosion_scene:
		var fx := explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		fx.global_position = global_position
	queue_free()
