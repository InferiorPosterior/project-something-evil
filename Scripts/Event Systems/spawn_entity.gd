class_name SpawnEntity extends EventAction

signal spawned(entity: Node2D)
signal defeated

@export var entity_scene: PackedScene
@export var effect_scene: PackedScene               # Drag Effect.tscn here in the Inspector
@export var reveal_delay: float = 0.5             
@export var wait_for_spawn: bool = true             

var entity: Node2D
var pending: bool = false                         

func _ready() -> void:
	if has_node("Preview"):
		$Preview.queue_free()        

func execute() -> void:
	if wait_for_spawn:
		await spawn()
	else:
		spawn()

func spawn() -> void:
	if pending:
		return

	if entity_scene == null:
		push_warning("%s has no entity_scene" % name)
		return

	pending = true

	# 1. Instantiate and play the effect right at the spawner's position
	if effect_scene:
		var effect_instance = effect_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(effect_instance)
		effect_instance.global_position = global_position

	# 2. Wait for the reveal delay
	if reveal_delay > 0.0:
		await get_tree().create_timer(reveal_delay).timeout
	
	pending = false
	if not is_inside_tree():
		return                        

	# 3. Spawn the actual enemy
	entity = entity_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(entity)
	entity.global_position = global_position
	entity.tree_exited.connect(defeated.emit)
	spawned.emit(entity)
