#THIS IS PLAYER CHARACTER SCRIPT
class_name Player extends CharacterBody2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var lives_component: LivesComponent = $LivesComponent

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	add_to_group("player")
	# DON'T LET THE SHORT HIT IMMUNITY (0.6s) OVERWRITE THE LONGER RESPAWN IMMUNITY
	hurtbox.damage_taken.connect(func(_dmg):
		if not lives_component.is_respawn_immune:
			health_component.set_temporary_immortality(0.6))
	# DEATH IS NOW HANDLED BY LivesComponent

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
