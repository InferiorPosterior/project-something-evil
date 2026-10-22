extends Node2D

const SPEED: int = 500

func _ready() -> void:
	$HitboxComponent.hit_landed.connect(queue_free)
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
