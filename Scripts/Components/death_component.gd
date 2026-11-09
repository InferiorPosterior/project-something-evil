class_name DeathComponent extends Node

@export var health: HealthComponent               # found automatically if it's a sibling named HealthComponent
@export var points: int = 100
@export var death_effect: PackedScene
@export var death_sound: AudioStream
@export var effect_offset: Vector2 = Vector2.ZERO
@export var free_delay: float = 0.05

var _done: bool = false

func _ready() -> void:
	if health == null:
		health = get_parent().get_node_or_null("HealthComponent") as HealthComponent
	if health == null:
		push_error("%s: no HealthComponent found" % get_path())
		return
	health.health_depleted.connect(_on_depleted)

func _on_depleted() -> void:
	if _done:
		return                                    # the signal can fire more than once on overkill
	_done = true

	var body := get_parent() as Node2D
	ScoreManager.add_points(points)

	body.process_mode = Node.PROCESS_MODE_DISABLED          # state machine, AI and animations stop
	if body is CollisionObject2D:
		body.set_deferred("collision_layer", 0)
	for area in body.find_children("*", "Area2D", true, false):
		area.set_deferred("monitoring", false)              # a dying enemy can't be hurt or hurt you
		area.set_deferred("monitorable", false)

	await get_tree().create_timer(free_delay).timeout
	if not is_instance_valid(body):
		return                                              # the level was reloaded in the meantime

	if death_effect:
		var fx := death_effect.instantiate() as Node2D
		get_tree().current_scene.add_child(fx)
		fx.global_position = body.global_position + effect_offset
	SoundManager.play_sound(death_sound, body.global_position)   # stays here if you keep the null check inside SoundManager
	body.queue_free()
