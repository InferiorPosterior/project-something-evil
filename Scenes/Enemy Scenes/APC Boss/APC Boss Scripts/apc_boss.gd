
class_name Apc extends Enemy

@export var same_level_tolerance: float = 24.0

var facing: float = 1.0
var ram_cooldown_left: float = 0.0


func _ready() -> void:
	# Find the nested HealthComponent BEFORE initializing Enemy.
	health = get_node_or_null("Components/HealthComponent") as HealthComponent

	if health == null:
		push_error("APC Boss: Cannot find Components/HealthComponent!")
		return

	# Parent now receives the correct HealthComponent reference.
	super._ready()

	if player is PhysicsBody2D:
		add_collision_exception_with(player)
		
	var boss_ui = get_tree().get_first_node_in_group("boss_ui")

	if boss_ui:
		boss_ui.set_boss(self, "APC BOSS")
		print("APC: BossUI registration requested")
	else:
		push_error("APC: BossUI not found")


func _physics_process(delta: float) -> void:
	ram_cooldown_left = maxf(ram_cooldown_left - delta, 0.0)


func face_player() -> void:
	if is_instance_valid(player):
		var dx := player.global_position.x - global_position.x
		if absf(dx) > 2.0:
			facing = signf(dx)


func is_player_on_same_level() -> bool:
	return is_instance_valid(player) and absf(player.global_position.y - global_position.y) <= same_level_tolerance


func _on_hurtbox_component_damage_taken(damage: int) -> void:
	if health == null:
		return

	print("APC Boss HP: ", health.current_health)
