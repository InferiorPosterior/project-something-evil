extends Node

signal score_changed(new_score: int)

const HIT_PENALTY: int = 200
const DEATH_PENALTY: int = 2000

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

func lose_points(amount: int) -> void:
	if amount <= 0:
		return
	score = maxi(score - amount, 0)          # the score never goes below zero
	score_changed.emit(score)

func on_player_health_changed(diff: int) -> void:
	if diff < 0:                             # only when health really dropped (heals and respawns are positive)
		lose_points(HIT_PENALTY)

func on_player_respawned() -> void:
	lose_points(DEATH_PENALTY)
