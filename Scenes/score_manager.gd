extends Node

signal score_changed(new_score: int)

var score: int = 0

func add_points(amount: int) -> void:
	if amount <= 0:
		return

	score += amount
	score_changed.emit(score)
	print("Points awarded: ", amount, " | Total score: ", score)


func complete_level(time_left: float) -> void:
	var bonus: int = maxi(int(time_left), 0) * 20
	add_points(bonus)
	print("Level completion bonus: ", bonus)


func reset_score() -> void:
	score = 0
	score_changed.emit(score)
	print("Score reset to 0")
