class_name EventAction extends Node2D

# Override this. It may use await, and the EventArea waits for it to finish before running the next action.
func execute() -> void:
	pass
