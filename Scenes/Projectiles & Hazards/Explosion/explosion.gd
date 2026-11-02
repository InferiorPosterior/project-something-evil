extends Node2D

@export var lifetime: float = 0.25
@export var radius: float = 28.0        # keep equal to the CircleShape2D radius

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, lifetime)
	tween.tween_callback(queue_free)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(1.0, 0.55, 0.1, 0.6))   # placeholder visual
