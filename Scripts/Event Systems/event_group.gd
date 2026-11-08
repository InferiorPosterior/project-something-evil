class_name EventGroup
extends EventAction

@export var run_in_parallel: bool = false # Ticked = run all children at once; Unticked = run top-to-bottom

func execute() -> void:
	for child in get_children():
		if child is EventAction:
			if run_in_parallel:
				child.execute() # fires them all at the exact same time
			else:
				await child.execute() # waits for one to finish before doing the next
