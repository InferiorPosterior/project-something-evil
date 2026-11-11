#THIS IS PLAYER CHARACTER SCRIPT
class_name Player extends CharacterBody2D

@export var hurt_sound: AudioStream

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var lives_component: LivesComponent = $LivesComponent

@export_group("Jump")
@export var jump_velocity: float = -400.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.12
@export var fall_gravity_multiplier: float = 1.6
@export var apex_gravity_multiplier: float = 0.6
@export var apex_threshold: float = 40.0

var coyote_left: float = 0.0
var buffer_left: float = 0.0

const SPEED = 300.0
		
func _ready() -> void:
	add_to_group("player")
	health_component.current_health_changed.connect(ScoreManager.on_player_health_changed)
	lives_component.respawned.connect(ScoreManager.on_player_respawned)
	
	# DON'T LET THE SHORT HIT IMMUNITY (0.6s) OVERWRITE THE LONGER RESPAWN IMMUNITY
	hurtbox.damage_taken.connect(func(_dmg):
		if not lives_component.is_respawn_immune:
			health_component.set_temporary_immortality(0.6))
			

func _physics_process(delta: float) -> void:
	# --- timers ---
	if is_on_floor():
		coyote_left = coyote_time
	else:
		coyote_left = maxf(coyote_left - delta, 0.0)

	if Input.is_action_just_pressed("jump"):
		buffer_left = jump_buffer_time
	else:
		buffer_left = maxf(buffer_left - delta, 0.0)

	# --- gravity ---
	if not is_on_floor():
		var g := get_gravity()
		if velocity.y > 0.0:
			g *= fall_gravity_multiplier
		elif absf(velocity.y) < apex_threshold:
			g *= apex_gravity_multiplier
		velocity += g * delta

	# --- jump: buffered press + coyote ground ---
	if buffer_left > 0.0 and coyote_left > 0.0:
		velocity.y = jump_velocity
		buffer_left = 0.0
		coyote_left = 0.0
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _on_hurtbox_component_damage_taken(damage: int) -> void:
	SoundManager.play_sound(hurt_sound, global_position)
	sprite.self_modulate = Color(20,20,20)
	animation_player.play("damage flash")
	
	await  get_tree().create_timer(0.1).timeout
	
	if is_instance_valid(sprite):
		sprite.self_modulate = Color.WHITE
