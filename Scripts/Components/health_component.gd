# THIS IS HEALTH COMPONENT SCRIPT
class_name HealthComponent extends Node

#SIGNALS
signal max_health_changed(diff: int)
signal current_health_changed(diff: int)
signal health_depleted

@export var max_health: int = 100 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality
var immortality_timer: Timer = null

@onready var current_health: int = max_health : set = set_current_health, get = get_current_health

#MAX HEALTH
func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value #IF SET MAX HEALTH(VALUE = 0), CLAMPED VALUE = 1
	
	if not clamped_value == max_health: #IF CLAMPED HEALTH ISN'T EQUAL TO MAX HEALTH, SEND SIGNAL HEALTH CHANGED
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
		
		if current_health > max_health:
			current_health = max_health

func get_max_health() -> int:
	return max_health

#IMMORTALITY
func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_temporary_immortality(time: float): 
	if immortality_timer == null:  # IF IMMORTALITY TIMER DOESNT EXIST, CREATE A TIMER NODE
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true # THIS MEANS THAT IT ONLY DOES IT ONCE, AND A CHILD IS ADDED TO THE CURRENT NODE
		add_child((immortality_timer))
	
	if immortality_timer.timeout.is_connected(set_immortality):  # CHECKS IF TIMEOUT SIGNAL IS CURRENTLY CONNECTED, THEN DISCONNECTS IT
		immortality_timer.timeout.disconnect(set_immortality)
	
	immortality_timer.set_wait_time(time) # SETS THE WAIT TIME 
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()

#CURRENT HEALTH
func set_current_health(value: int):
	if value < current_health and immortality: #IF IMMORTALITY IS ACTIVE, DON'T DEDUCT HEALTH WHEN DAMAGED
		return
	
	var clamped_value = clampi(value, 0, max_health) # CLAMP VALUE TO MINIMUM 0 AND MAX AT MAX HEALTH
	
	if clamped_value != current_health:
		var difference = clamped_value - current_health
		current_health = clamped_value
		current_health_changed.emit(difference)
		
		if current_health <= 0: # CHECK IF HEALTH DEPLETED THEN EMIT SIGNAL
			health_depleted.emit()

func get_current_health() -> int:
	return current_health
