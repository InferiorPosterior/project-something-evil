class_name AmmoWeapon extends Node2D

signal depleted

@export var max_ammo: int = 30
@export var fire_interval: float = 0.1
@export var start_delay: float = 0.5           # pause after being switched on, before the first shot
@export var aim_turn_speed: float = 0.0        # deg/s toward the player; 0 = doesn't rotate

var ammo: int = 0
var enabled: bool = false
var cooldown: float = 0.0
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func enable() -> void:                         # called by the turret; refills and starts firing
	ammo = max_ammo
	cooldown = start_delay
	enabled = true

func _physics_process(delta: float) -> void:
	if not enabled or not is_instance_valid(player):
		return

	if aim_turn_speed > 0.0:
		var target_angle := (player.global_position - global_position).angle()
		var step := deg_to_rad(aim_turn_speed) * delta
		global_rotation += clampf(angle_difference(global_rotation, target_angle), -step, step)

	cooldown -= delta
	if cooldown <= 0.0:
		ammo -= 1
		shoot()
		cooldown = fire_interval
		if ammo <= 0:
			enabled = false
			depleted.emit()

func shoot() -> void:                          # each weapon overrides this
	pass
