extends Area2D

@export var speed: float = 200.0
var direction: Vector2 = Vector2.RIGHT   # set by the shooter before it enters the scene

func _ready() -> void:
	rotation = direction.angle()
	$HitboxComponent.hit_landed.connect(queue_free)   # vanish when the hit lands
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(4.0).timeout.connect(queue_free)   # despawn if it never hits anything

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):   # walls stop it; the player is handled by the hitbox
		queue_free()
