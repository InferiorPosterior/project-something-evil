extends Area2D

@export var explosion_scene: PackedScene       # a SMALL explosion (see setup)
@export var lifetime: float = 4.0

var direction: Vector2 = Vector2.RIGHT         # set by the autocannon before it's added
var speed: float = 260.0
var exploded: bool = false

func _ready() -> void:
	rotation = direction.angle()
	body_entered.connect(func(_body): explode.call_deferred())   # world or the player
	get_tree().create_timer(lifetime).timeout.connect(queue_free) # expires quietly if it hits nothing

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func explode() -> void:
	if exploded:
		return
	exploded = true
	if explosion_scene:
		var fx := explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		fx.global_position = global_position
	queue_free()
