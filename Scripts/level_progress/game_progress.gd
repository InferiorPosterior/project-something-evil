
extends Node

var level2_unlocked: bool = false
var level3_unlocked: bool = false

const SAVE_PATH = "user://game_progress.cfg"


func _ready():
	load_progress()


func unlock_level2():
	if level2_unlocked == false:
		level2_unlocked = true
		save_progress()
		print("Level 2 unlocked!")


func unlock_level3():
	if level3_unlocked == false:
		level3_unlocked = true
		save_progress()
		print("Level 3 unlocked!")
		

func save_progress():
	var config = ConfigFile.new()

	config.set_value("progress", "level2_unlocked", level2_unlocked)
	config.set_value("progress", "level3_unlocked", level3_unlocked)
	config.save(SAVE_PATH)


func load_progress():
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)

	if error == OK:
		level2_unlocked = config.get_value(
			"progress",
			"level2_unlocked",
			false
		)

		level3_unlocked = config.get_value(
			"progress",
			"level3_unlocked",
			false
		)
