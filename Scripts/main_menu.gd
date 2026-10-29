
extends Control

# Runs when the main menu is ready.
func _ready():
	# Connects each button to its corresponding function.
	$CenterContainer/Panel/Control/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/Panel/Control/LevelSelectButton.pressed.connect(_on_level_select_pressed)
	$CenterContainer/Panel/Control/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/Panel/Control/QuitButton.pressed.connect(_on_quit_pressed)


# Runs when Start Game is clicked.
func _on_start_pressed():
	# Opens the existing game scene.
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

#Runs when Select Level is clicked.
func _on_level_select_pressed():
	# Opens the level selection scene.
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

# Runs when Settings is clicked.
func _on_settings_pressed():
	# Placeholder until we build the settings menu.
	print("Settings button unavailable..for now!")


# Runs when Quit is clicked.
func _on_quit_pressed():
	# Closes the game.
	get_tree().quit()
