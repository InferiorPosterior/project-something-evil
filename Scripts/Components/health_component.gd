
class_name HealthComponent
extends Node

# ==================================================
# SIGNALS
# ==================================================
signal max_health_changed(diff: int)
signal current_health_changed(diff: int)
signal health_depleted


# ==================================================
# MAX HEALTH
# ==================================================
@export var max_health: int = 100:
	set = set_max_health,
	get = get_max_health


# ==================================================
# IMMORTALITY
# ==================================================
@export var immortality: bool = false:
	set = set_immortality,
	get = get_immortality

@export_group("Damage Protection")
@export var damage_immortality_duration: float = 1.5

var immortality_timer: Timer = null


# ==================================================
# PLAYER DIFFICULTY
# Enable only for the player.
# ==================================================
@export_group("Player Difficulty")
@export var use_player_difficulty: bool = false

@export_enum("Hard:100", "Normal:300", "Easy:500")
var difficulty_max_health: int = 300


# ==================================================
# PASSIVE HEALTH REGENERATION
# Enable only for the player.
# ==================================================
@export_group("Passive Regeneration")
@export var enable_passive_regen: bool = false
@export var regen_amount: int = 5
@export var regen_delay: float = 3.0
@export var regen_interval: float = 1.0

var regen_delay_timer: float = 0.0
var regen_tick_timer: float = 0.0


# ==================================================
# CURRENT HEALTH
# ==================================================
var current_health: int = 100:
	set = set_current_health,
	get = get_current_health


# ==================================================
# INITIALIZATION
# ==================================================
func _ready() -> void:
	# Apply difficulty-based maximum HP when enabled.
	if use_player_difficulty:
		set_max_health(difficulty_max_health)

	# Start with full health.
	current_health = max_health


# ==================================================
# PASSIVE REGENERATION PROCESS
# ==================================================
func _process(delta: float) -> void:
	if not enable_passive_regen:
		return

	# Do not regenerate when dead or at full health.
	if current_health <= 0 or current_health >= max_health:
		regen_delay_timer = 0.0
		regen_tick_timer = 0.0
		return

	# Wait until enough time has passed since the last hit.
	regen_delay_timer += delta

	if regen_delay_timer < regen_delay:
		return

	# Restore health at the configured interval.
	regen_tick_timer += delta

	if regen_tick_timer >= regen_interval:
		regen_tick_timer -= regen_interval
		heal(regen_amount)


# ==================================================
# MAX HEALTH SETTER / GETTER
# ==================================================
func set_max_health(value: int) -> void:
	var clamped_value: int = maxi(value, 1)

	if clamped_value == max_health:
		return

	var difference: int = clamped_value - max_health

	max_health = clamped_value
	max_health_changed.emit(difference)

	# Prevent current HP from exceeding maximum HP.
	if current_health > max_health:
		current_health = max_health


func get_max_health() -> int:
	return max_health


# ==================================================
# IMMORTALITY SETTER / GETTER
# ==================================================
func set_immortality(value: bool) -> void:
	immortality = value


func get_immortality() -> bool:
	return immortality


# ==================================================
# TEMPORARY IMMORTALITY
# ==================================================
func set_temporary_immortality(time: float) -> void:
	if time <= 0.0:
		immortality = false
		return

	# Create the timer only once.
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
		immortality_timer.timeout.connect(
			_on_immortality_timeout
		)

	# Restart the timer if hit again.
	immortality = true
	immortality_timer.start(time)


func _on_immortality_timeout() -> void:
	immortality = false


# ==================================================
# CURRENT HEALTH SETTER / GETTER
# ==================================================
func set_current_health(value: int) -> void:
	# Ignore damage while immortal.
	if value < current_health and immortality:
		return

	# Clamp HP between zero and maximum health.
	var clamped_value: int = clampi(value, 0, max_health)

	if clamped_value == current_health:
		return

	var difference: int = clamped_value - current_health

	# Reset regeneration delay when damaged.
	if difference < 0:
		regen_delay_timer = 0.0
		regen_tick_timer = 0.0

	current_health = clamped_value

	current_health_changed.emit(difference)

	# Notify listeners when health reaches zero.
	if current_health <= 0:
		health_depleted.emit()


func get_current_health() -> int:
	return current_health


# ==================================================
# TAKE DAMAGE
# Used by both players and enemies.
# ==================================================
func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	if current_health <= 0 or immortality:
		return

	# Subtract HP through the existing setter.
	current_health = current_health - amount

	# Start invincibility frames after a successful hit.
	if damage_immortality_duration > 0.0:
		set_temporary_immortality(
			damage_immortality_duration
		)


# ==================================================
# HEAL
# Used by both players and enemies.
# ==================================================
func heal(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return

	current_health = mini(
		current_health + amount,
		max_health
	)
