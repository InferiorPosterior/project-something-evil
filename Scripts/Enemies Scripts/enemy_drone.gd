class_name Drone extends CharacterBody2D

@export var health: HealthComponent
@export var explosion_scene: PackedScene          # assign explosion.tscn
@export var detection_range: float = 260.0

@onready var contact_sensor: Area2D = $ContactSensor

var player: Node2D
var exploded: bool = false

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING   # free flight, no floor or gravity logic
	player = get_tree().get_first_node_in_group("player")
	# Fly through the player's body: the sensor triggers the explosion instead of a collision bounce
	if player is PhysicsBody2D:
		add_collision_exception_with(player)
	contact_sensor.body_entered.connect(_on_contact_sensor_body_entered)

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)

func _on_contact_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		explode.call_deferred()      # deferred: can't spawn physics nodes inside a physics callback

func explode() -> void:
	if exploded:                     # death and contact can happen on the same frame
		return
	exploded = true
	if explosion_scene:
		var fx := explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		fx.global_position = global_position
	queue_free()


func _on_health_component_health_depleted() -> void:
	explode.call_deferred()
