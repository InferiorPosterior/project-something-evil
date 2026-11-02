
extends Node

signal score_changed(new_score: int)

var score: int = 0

const ENEMY_POINTS: Dictionary = {
	"Chaser": 100,
	"Gunner": 200,
	"Grenadier": 200,
	"Drone": 200,
	"Lunger": 300,
	"Turret": 300,
	"Brute": 500,
	"Boss": 2000
}


func add_enemy_points(enemy_type: String) -> void:
	if not ENEMY_POINTS.has(enemy_type):
		push_warning("Unknown enemy type: " + enemy_type)
		return

	add_points(ENEMY_POINTS[enemy_type])


func add_points(amount: int) -> void:
	if amount <= 0:
		return

	score += amount
	score_changed.emit(score)
	print("Points awarded: ", amount, " | Total score: ", score)


func complete_level(time_left: float) -> void:
	var bonus: int = maxi(int(time_left), 0) * 10
	add_points(bonus)
	print("Level completion bonus: ", bonus)


func reset_score() -> void:
	score = 0
	score_changed.emit(score)
	print("Score reset to 0")
