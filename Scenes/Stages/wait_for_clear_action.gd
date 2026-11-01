class_name WaitForClearAction extends EventAction

func execute() -> void:
	while _alive_count() > 0:
		await get_tree().create_timer(0.25).timeout
		if not is_inside_tree():
			return

# Counts the spawners next to this node whose enemy is still on its way or alive
func _alive_count() -> int:
	var count := 0
	for sibling in get_parent().get_children():
		if sibling is SpawnEntity and (sibling.pending or is_instance_valid(sibling.entity)):
			count += 1
	return count
