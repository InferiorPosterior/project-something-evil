
extends Control

var opened_from_pause: bool = false


func _ready():
	#This lets the level select to work while the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Background/CenterContainer/Panel/Control/Level1Button.pressed.connect(_on_level1_pressed)
	$Background/CenterContainer/Panel/Control/Level2Button.pressed.connect(_on_level2_pressed)
	$Background/CenterContainer/Panel/Control/BackButton.pressed.connect(_on_back_pressed)

	update_level_buttons()


func update_level_buttons():
	var level2_button = $Background/CenterContainer/Panel/Control/Level2Button

	if GameProgress.level2_unlocked:
		level2_button.text = "LEVEL 2 — DELIVER US FROM EVIL"
		level2_button.disabled = false
	else:
		level2_button.text = "LEVEL 2 — LOCKED"
		level2_button.disabled = true


func _on_level1_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/stage_1_prelude_to_evil.tscn")


func _on_level2_pressed():
	if GameProgress.level2_unlocked:
		print("Level 2 selected!")

		# We load the Level 2 scene here
		# after its scene has been created.


func _on_back_pressed():
	if opened_from_pause:
		get_parent().get_node("PauseMenu").show()
		queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
