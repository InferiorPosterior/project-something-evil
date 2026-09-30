#THIS IS THE PROJECTILE SCRIPT
extends Node2D

@onready var timer: Timer = $Timer
const SPEED: int = 500

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	print ("I despawned!")
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	print("Hit!")
	queue_free()
	
