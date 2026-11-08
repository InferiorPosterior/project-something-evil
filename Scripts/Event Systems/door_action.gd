class_name DoorAction extends EventAction

@export var doors: Array[Door] = []
@export var close: bool = true                  # ticked = close the doors; unticked = open them
@export var wait_for_doors: bool = true         # the next action waits until the doors have finished their animation

func execute() -> void:
	for door in doors:
		if close:
			door.close()
		else:
			door.open()

	if wait_for_doors:
		for door in doors:
			if door.moving:
				await door.finished_moving      # a door that finished already is skipped, so the order doesn't matter
