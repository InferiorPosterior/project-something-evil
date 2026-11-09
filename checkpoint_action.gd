class_name CheckpointAction extends EventAction

@export var use_player_position: bool = false      # ticked = the spot where the player entered; unticked = this node's own position

func execute() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var lives := player.get_node_or_null("LivesComponent") as LivesComponent
	if lives == null:
		push_warning("%s: the player has no LivesComponent" % name)
		return
	lives.set_checkpoint(player.global_position if use_player_position else global_position)
