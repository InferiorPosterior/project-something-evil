class_name LungerWindup extends State

@export var windup_time: float = 0.5

@onready var lunger: Lunger = get_parent().get_parent()
var timer: float = 0.0

func enter_state() -> void:
	lunger.get_node("AnimatedSprite2D").play("windup")
	timer = windup_time
	lunger.velocity.x = 0
	if is_instance_valid(lunger.player):
		# Aim is locked NOW, at the player's position when the windup begins.
		lunger.dash_direction = (lunger.player.global_position - lunger.global_position).normalized()
	if lunger.sprite:
		lunger.sprite.modulate = Color(1.0, 0.45, 0.45)   # red tint = "about to lunge"

func exit_state() -> void:
	if lunger.sprite:
		lunger.sprite.modulate = Color.WHITE

func physics_update(delta: float) -> void:
	lunger.apply_gravity(delta)
	lunger.velocity.x = 0
	lunger.move_and_slide()

	timer -= delta
	if timer <= 0.0:
		Transitioned.emit(self, "lungerdash")
