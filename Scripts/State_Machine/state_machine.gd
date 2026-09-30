class_name StateMachine extends Node

@export var initial_state : State

var current_state: State
var states: Dictionary ={}

func _ready() -> void:
	for child in get_children(): # CHECKS ALL NODES ATTACHED TO STATEMACHINE
		if child is State:
			states[child.name.to_lower()] = child
			
			#CONNECT CHILD STATE'S Transitioned SIGNAL TO STATE MACHINE
			child.Transitioned.connect(on_child_transition) 
	
	# CHECK IF INITIAL STATE WAS ASSIGNED IN INSPECTOR, THEN SETS IT AS CURRENT STATE
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func on_child_transition (state, new_state_name):
	# Prevent inactive states from changing states
	if state != current_state:
		return
	
	# Get the next state
	var new_state = states.get(new_state_name.to_lower())
	# If there is no next state, abort transition
	if !new_state:
		return
	
	# Exit previous state and transition into the next state
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	current_state = new_state
