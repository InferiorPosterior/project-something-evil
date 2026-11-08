# THIS IS ENEMY SCRIPT
class_name Chaser extends Enemy

func _ready() -> void:
	super._ready()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _process(_delta: float) -> void:
	if absf(velocity.x) > 1.0:
		$AnimatedSprite2D.flip_h = velocity.x < 0.0
		
