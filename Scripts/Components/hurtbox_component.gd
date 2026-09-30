#THIS IS HURTBOX COMPONENT SCRIPT
class_name HurtboxComponent extends Area2D

signal damage_taken(damage: int)

@export var health: HealthComponent

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox != null:
		health.current_health -=hitbox.damage
		print(health.current_health)
		damage_taken.emit(hitbox.damage)
