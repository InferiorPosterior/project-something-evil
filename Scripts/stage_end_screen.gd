extends CanvasLayer

@export_file("*.tscn") var main_menu_scene: String = "res://Scenes/main_menu.tscn"
var next_scene: String = ""              # set by LevelEndAction before the screen is added

@export var sound_effect: AudioStream
@onready var panel: Control = %Panel
@onready var next_button: Button = %NextButton
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MainMenuButton

func _ready() -> void:
	SoundManager.play_sound(sound_effect, null)
	process_mode = Node.PROCESS_MODE_ALWAYS      # keeps working while the level underneath is paused
	layer = 100                                  # above the HUD and the pause menu
	get_tree().paused = true                     # freezes enemies, projectiles and the player

	next_button.visible = next_scene != ""       # hides Continue if there's nowhere to go
	next_button.pressed.connect(_go.bind(next_scene))
	retry_button.pressed.connect(_retry)
	menu_button.pressed.connect(_go.bind(main_menu_scene))
	(next_button if next_button.visible else retry_button).grab_focus()    # works with keyboard and controller

	panel.modulate.a = 0.0                       # fade in
	create_tween().tween_property(panel, "modulate:a", 1.0, 0.4)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()    # stops the pause menu from opening on top of this screen

func _go(path: String) -> void:
	get_tree().paused = false                    # must be unpaused before the scene changes, or the next scene starts frozen
	get_tree().change_scene_to_file(path)

func _retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
