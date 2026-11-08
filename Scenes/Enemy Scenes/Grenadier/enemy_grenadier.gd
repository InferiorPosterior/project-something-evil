
class_name Grenadier extends Enemy

@export var grenade_scene: PackedScene
@export var min_distance: float = 160.0
@export var max_distance: float = 240.0
@export var throw_offset: Vector2 = Vector2(0, -6)


func _ready() -> void:
	super._ready()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _process(delta: float) -> void:
	if absf(velocity.x) > 1.0:
		$AnimatedSprite2D.flip_h = velocity.x < 0.0


func throw_grenade() -> void:
	if grenade_scene == null or not is_instance_valid(player):
		return

	var origin := global_position + throw_offset
	var target := player.global_position
	var g := get_gravity().y

	var flight_time := clampf(origin.distance_to(target) / 260.0, 0.6, 1.4)

	var vel := Vector2(
		(target.x - origin.x) / flight_time,
		(target.y - origin.y) / flight_time - 0.5 * g * flight_time
	)

	var grenade: Grenade = grenade_scene.instantiate()
	get_tree().current_scene.add_child(grenade)
	grenade.global_position = origin

	grenade.launch(vel, self)
