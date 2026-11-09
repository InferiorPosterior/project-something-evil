extends Control # Changed from CanvasLayer

func _ready() -> void:
	_connect_to_player.call_deferred()

func _connect_to_player() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var lives_component := player.get_node_or_null("LivesComponent") as LivesComponent
	if lives_component == null:
		return
	lives_component.lives_changed.connect(_update_label)
	_update_label(lives_component.lives)

func _update_label(lives: int) -> void:
	%LivesLabel.text = "LIVES: %d" % lives
