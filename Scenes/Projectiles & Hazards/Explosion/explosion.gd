extends Node2D

@export var lifetime: float = 0.25
@export var radius: float = 28.0        # keep equal to the CircleShape2D radius

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# 1. Connect to the built-in signal that fires when the animation ends
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	# 2. Play your explosion animation name (change "explosion" to your actual animation name)
	animated_sprite.play("explosion")

func _on_animation_finished() -> void:
	# 3. Safely delete the node from the scene tree when the animation completes
	queue_free()
