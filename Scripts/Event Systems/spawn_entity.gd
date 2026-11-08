class_name SpawnEntity extends EventAction

signal spawned(entity: Node2D)
signal defeated

@export var entity_scene: PackedScene
@export var spawn_effect: PackedScene               # optional: a self-freeing effect (portal, smoke, flash)
@export var reveal_delay: float = 0.5               # the enemy appears this long after the effect starts
@export var wait_for_spawn: bool = true             # false = the sequence moves on at once (lets several spawn together)

var entity: Node2D
var pending: bool = false                           # true between starting the spawn and the enemy appearing

func _ready() -> void:
	if has_node("Preview"):
		$Preview.queue_free()        # gone as soon as the game starts; it only exists to guide you in the editor

func execute() -> void:
	if wait_for_spawn:
		await spawn()
	else:
		spawn()

# Also callable directly, for example by connecting EventArea.triggered to it in the editor
func spawn() -> void:
	if entity_scene == null:
		push_warning("%s has no entity_scene" % name)
		return

	pending = true
	if spawn_effect:
		var fx := spawn_effect.instantiate() as Node2D
		get_tree().current_scene.add_child(fx)
		fx.global_position = global_position

	if reveal_delay > 0.0:
		await get_tree().create_timer(reveal_delay).timeout
	pending = false
	if not is_inside_tree():
		return                                      # the level was reloaded during the delay

	entity = entity_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(entity)
	entity.global_position = global_position
	entity.tree_exited.connect(defeated.emit)
	spawned.emit(entity)
