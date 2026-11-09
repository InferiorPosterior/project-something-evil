extends Label

@export var reset_on_stage_start: bool = true     # untick on a stage that should continue the previous score

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)    # connect first, so the reset below updates the label
	if reset_on_stage_start:
		ScoreManager.reset_score()                           # emits score_changed, so the label shows 0
	else:
		_on_score_changed(ScoreManager.score)

func _on_score_changed(new_score: int) -> void:
	text = "SCORE: %06d" % new_score
