# THIS IS GAME OVER SCREEN SCRIPT
extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true # FREEZES THE GAME BEHIND THE SCREEN (THIS NODE USES PROCESS MODE "ALWAYS")
	%RestartButton.pressed.connect(_on_restart_pressed)
	%MainMenuButton.pressed.connect(_on_main_menu_pressed)
	%RestartButton.grab_focus()

func _input(event: InputEvent) -> void:
	# STOPS ESC FROM OPENING/CLOSING THE PAUSE MENU OVER THE GAME OVER SCREEN
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene() # RELOADS THE LEVEL, PLAYER GETS 3 LIVES AGAIN, ENEMIES COME BACK

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
