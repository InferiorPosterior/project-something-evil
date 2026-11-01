class_name EventAction extends Node

# Override this. It may use await, and the EventArea waits for it to finish before running the next action.
func execute() -> void:
	pass
