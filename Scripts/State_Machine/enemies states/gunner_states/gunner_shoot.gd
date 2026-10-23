class_name GunnerShoot extends State

@export var windup: float = 0.4          # delay before the FIRST shot, so you get a moment to react
@export var fire_interval: float = 1.2   # seconds between shots after that

@onready var enemy: Gunner = get_parent().get_parent()
var cooldown: float = 0.0

func enter_state() -> void:
	cooldown = windup
	enemy.velocity.x = 0

func physics_update(delta: float) -> void:
	enemy.apply_gravity(delta)
	enemy.velocity.x = 0
	enemy.move_and_slide()

	if not enemy.is_on_floor():
		Transitioned.emit(self, "enemyfall")
		return

	# The key line: leave only when the player is beyond the LARGER exit range
	if enemy.distance_to_player() > enemy.shoot_exit_range:
		Transitioned.emit(self, "enemychase")
		return

	cooldown -= delta
	if cooldown <= 0.0:
		fire()
		cooldown = fire_interval

func fire() -> void:
	if enemy.projectile_scene == null or not is_instance_valid(enemy.player):
		return
	var bullet = enemy.projectile_scene.instantiate()
	var origin := enemy.global_position + enemy.muzzle_offset
	bullet.direction = (enemy.player.global_position - origin).normalized()  # aimed at you at the moment of firing
	enemy.get_tree().current_scene.add_child(bullet)
	bullet.global_position = origin
