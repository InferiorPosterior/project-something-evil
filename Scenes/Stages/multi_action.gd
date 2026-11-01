class_name MultiAction extends EventAction

signal all_done
var remaining: int = 0

func execute() -> void:
	var actions: Array[EventAction] = []
	for child in get_children():
		if child is EventAction:
			actions.append(child)
	if actions.is_empty():
		return

	remaining = actions.size()
	for action in actions:
		_run_one(action)                  # not awaited, so they all start at once
	if remaining > 0:
		await all_done

func _run_one(action: EventAction) -> void:
	await action.execute()
	remaining -= 1
	if remaining == 0:
		all_done.emit()
