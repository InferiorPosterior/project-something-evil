
extends Control

var score_label: Label


func _ready() -> void:
	print("PointUI loaded")

	score_label = get_node_or_null("PanelContainer/ScoreLabel") as Label

	if score_label == null:
		push_error("PointUI: ScoreLabel not found. Check your scene tree.")
		return

	if not ScoreManager.score_changed.is_connected(_on_score_changed):
		ScoreManager.score_changed.connect(_on_score_changed)

	_on_score_changed(ScoreManager.score)


func _on_score_changed(new_score: int) -> void:
	if score_label == null:
		return

	score_label.text = "POINTS: %06d" % new_score
	print("Current score: ", new_score)
