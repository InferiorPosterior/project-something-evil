extends Control

@export var menu_track: AudioStream

# Runs when the main menu is ready.
func _ready():
	SoundManager.play_music(menu_track)
	
	# Connects each button to its corresponding function.
	$CenterContainer/Panel/Control/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/Panel/Control/LevelSelectButton.pressed.connect(_on_level_select_pressed)
	$CenterContainer/Panel/Control/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/Panel/Control/QuitButton.pressed.connect(_on_quit_pressed)


# Runs when New Game is clicked.
func _on_start_pressed():
	# Opens the save select scene in "new game" mode.
	SaveSelect.pending_mode = SaveSelect.Mode.NEW
	get_tree().change_scene_to_file("res://Scenes/save_select.tscn")

# Runs when Load Game is clicked.
func _on_level_select_pressed():
	# Opens the same save select scene in "load game" mode.
	SaveSelect.pending_mode = SaveSelect.Mode.LOAD
	get_tree().change_scene_to_file("res://Scenes/save_select.tscn")

# Runs when Settings is clicked.
func _on_settings_pressed():
	# Opens the settings screen on top of the main menu,
	# so the menu music keeps playing while volume is adjusted.
	var settings_scene: PackedScene = load("res://Scenes/settings_menu.tscn")
	var settings = settings_scene.instantiate()
	add_child(settings)
	$CenterContainer.hide()  # hide the menu buttons and title behind it
	settings.tree_exited.connect(_on_settings_closed)


func _on_settings_closed():
	$CenterContainer.show()

# Runs when Quit is clicked.
func _on_quit_pressed():
	# Closes the game.
	get_tree().quit()
