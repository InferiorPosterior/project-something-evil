# THIS IS LIVES COMPONENT SCRIPT
# Drop it on any character as a child node. It listens to the HealthComponent,
# and when health runs out it spends a life and respawns the character in place.
# When no lives are left it shows the game over screen.
class_name LivesComponent extends Node

signal lives_changed(lives: int)   # use this later for a lives HUD
signal respawned
signal game_over

@export var health: HealthComponent
@export var max_lives: int = 3
@export var respawn_immunity: float = 3.0     # seconds of invincibility after respawning
@export var blink_interval: float = 0.1       # seconds per blink step
@export var blink_alpha: float = 0.2          # how transparent the sprite gets while blinking
@export var game_over_scene: PackedScene

var lives: int
var is_respawn_immune: bool = false
var respawn_at_safe_spot: bool = false        # set by Killzone, so the player doesn't respawn inside a pit

var _body: CharacterBody2D
var _last_safe_position: Vector2
var _dying: bool = false
var _blink_tween: Tween

func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	if health == null:
		health = _body.get_node_or_null("HealthComponent")
	lives = max_lives
	_last_safe_position = _body.global_position
	health.health_depleted.connect(_on_health_depleted)
	lives_changed.emit(lives)

func _physics_process(_delta: float) -> void:
	# REMEMBER THE LAST PLACE THE CHARACTER STOOD ON THE GROUND
	if _body.is_on_floor():
		_last_safe_position = _body.global_position

func _on_health_depleted() -> void:
	if _dying: # IGNORE EXTRA DEATHS WHILE ALREADY RESPAWNING
		return
	_dying = true
	lives -= 1
	lives_changed.emit(lives)
	if lives > 0:
		_respawn.call_deferred()
	else:
		_trigger_game_over.call_deferred()

func _respawn() -> void:
	if respawn_at_safe_spot:
		_body.global_position = _last_safe_position
		respawn_at_safe_spot = false
	_body.velocity = Vector2.ZERO
	health.current_health = health.max_health
	health.set_temporary_immortality(respawn_immunity)
	_start_blink()
	_dying = false
	respawned.emit()

func _start_blink() -> void:
	if _blink_tween:
		_blink_tween.kill()
	is_respawn_immune = true
	var cycles := maxi(1, roundi(respawn_immunity / (blink_interval * 2.0)))
	_blink_tween = create_tween().set_loops(cycles)
	_blink_tween.tween_property(_body, "modulate:a", blink_alpha, blink_interval)
	_blink_tween.tween_property(_body, "modulate:a", 1.0, blink_interval)
	_blink_tween.finished.connect(_end_blink)

func _end_blink() -> void:
	is_respawn_immune = false
	_body.modulate.a = 1.0

func _trigger_game_over() -> void:
	if game_over_scene:
		get_tree().current_scene.add_child(game_over_scene.instantiate())
	game_over.emit()
