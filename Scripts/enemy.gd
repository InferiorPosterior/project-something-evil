# THIS IS ENEMY SCRIPT
extends CharacterBody2D

@export var health : HealthComponent

func _on_health_component_health_depleted() -> void:
	queue_free()
	print("Enemy fucking died")
