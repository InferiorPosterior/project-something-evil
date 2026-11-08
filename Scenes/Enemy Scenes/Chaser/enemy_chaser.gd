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
	
func _on_hurtbox_damage_taken(damage: int) -> void:

	sprite.self_modulate = Color(4.567, 4.567, 4.567, 1.0)
	await  get_tree().create_timer(0.1).timeout
	
	if is_instance_valid(sprite):
		sprite.self_modulate = Color.WHITE
	
