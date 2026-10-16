#THIS IS HURTBOX COMPONENT SCRIPT
class_name HurtboxComponent extends Area2D

signal damage_taken(damage: int)

@export var health: HealthComponent

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent and health != null:
		health.current_health -= area.damage
		damage_taken.emit(area.damage)
		area.hit_landed.emit()
