class_name RegenComponent
extends Node

@export var heal_sound : AudioStream
@export var health: HealthComponent        # found automatically if left empty (a sibling named HealthComponent)
@export var enabled: bool = true           # toggle from other scripts, for example to stop regen during a boss fight
@export var amount: int = 5                # HP restored per tick
@export var delay: float = 3.0             # seconds without taking damage before regen starts
@export var interval: float = 1.0          # seconds between ticks

var _delay_left: float = 0.0
var _tick_left: float = 0.0


func _ready() -> void:
	if health == null:
		health = get_parent().get_node_or_null("HealthComponent") as HealthComponent
	if health == null:
		push_error("%s: no HealthComponent found" % get_path())
		set_process(false)
		return

	health.current_health_changed.connect(_on_health_changed)
	reset_delay()


# Restarts the wait before regeneration. Call it from anything that should interrupt regen.
func reset_delay() -> void:
	_delay_left = delay
	_tick_left = interval


func _on_health_changed(diff: int) -> void:
	if diff < 0:
		reset_delay()                      # taking damage restarts the wait


func _process(delta: float) -> void:
	if not enabled:
		return

	# Nothing to restore when dead or already at full health.
	if health.current_health <= 0 or health.current_health >= health.max_health:
		reset_delay()
		return

	# Wait until enough time has passed since the last hit.
	if _delay_left > 0.0:
		_delay_left -= delta
		return

	# Restore health at the configured interval.
	_tick_left -= delta
	if _tick_left <= 0.0:
		_tick_left += interval
		SoundManager.play_sound(heal_sound,null) 
		health.heal(amount)
