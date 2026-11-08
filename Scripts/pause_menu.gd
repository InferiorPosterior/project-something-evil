
extends Control

# Runs automatically when the PauseMenu scene is ready.
func _ready():
	# Allows the pause menu to keep working even when the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Hides the pause menu when the game first starts.
	hide()

	# Connects each button's pressed signal to its function.
	# When a button is clicked, its corresponding function will run.
	$CenterContainer/Panel/Control/ResumeButton.pressed.connect(_on_resume_pressed)
	$CenterContainer/Panel/Control/RestartButton.pressed.connect(_on_restart_pressed)
	$CenterContainer/Panel/Control/LevelSelectButton.pressed.connect(_on_level_select_pressed)
	$CenterContainer/Panel/Control/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$CenterContainer/Panel/Control/QuitButton.pressed.connect(_on_quit_pressed)


# Checks for keyboard input, such as pressing Escape.
func _input(event):
	# Checks whether the player pressed the ui_cancel key (usually Escape).
	# is_echo() prevents repeated key inputs from holding the key down.
	if event.is_action_pressed("ui_cancel") and not event.is_echo():

		# If the game is already paused, pressing Escape resumes it.
		if get_tree().paused:
			resume_game()

		# Otherwise, pressing Escape pauses the game.
		else:
			pause_game()


# Pauses the game and displays the pause menu.
func pause_game():
	show()  # Makes the pause menu visible.
	get_tree().paused = true  # Freezes gameplay.


# Resumes gameplay and hides the pause menu.
func resume_game():
	get_tree().paused = false  # Allows gameplay to continue.
	hide()  # Makes the pause menu invisible.


# Runs when the Resume button is clicked.
func _on_resume_pressed():
	resume_game()  # Resumes the game.


# Runs when the Restart button is clicked.
func _on_restart_pressed():
	# Unpauses the game before restarting the level.
	get_tree().paused = false

	# Reloads the current scene from the beginning.
	get_tree().reload_current_scene()


func _on_level_select_pressed():
	var level_select_scene = load("res://Scenes/level_select.tscn")
	var level_select = level_select_scene.instantiate()

	level_select.opened_from_pause = true

	get_parent().add_child(level_select)
	hide()


# Runs when the Main Menu button is clicked.
func _on_main_menu_pressed():
	# Unpauses the game before changing scenes.
	get_tree().paused = false

	# Loads the main menu scene.
	# Make sure this file exists at the specified path.
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


# Runs when the Quit button is clicked.
func _on_quit_pressed():
	# Closes the game application.
	get_tree().quit()
