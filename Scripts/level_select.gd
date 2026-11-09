
extends Control

var opened_from_pause: bool = false

@export var level1: PackedScene
@export var level2: PackedScene
@export var level3: PackedScene


func _ready():
	# Allows Level Select to work while the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS

	$Background/CenterContainer/Panel/Control/Level1Button.pressed.connect(_on_level1_pressed)
	$Background/CenterContainer/Panel/Control/Level2Button.pressed.connect(_on_level2_pressed)
	$Background/CenterContainer/Panel/Control/Level3Button.pressed.connect(_on_level3_pressed)
	$Background/CenterContainer/Panel/Control/BackButton.pressed.connect(_on_back_pressed)

	update_level_buttons()


func update_level_buttons():
	var level2_button = $Background/CenterContainer/Panel/Control/Level2Button
	var level3_button = $Background/CenterContainer/Panel/Control/Level3Button

	# Level 2
	if GameProgress.level2_unlocked:
		level2_button.text = "LEVEL 2 — SOMETHING EVIL WILL HAPPEN"
		level2_button.disabled = false
	else:
		level2_button.text = "LEVEL 2 — LOCKED"
		level2_button.disabled = true

	# Level 3
	if GameProgress.level3_unlocked:
		level3_button.text = "LEVEL 3 — DELIVER US FROM EVIL"
		level3_button.disabled = false
	else:
		level3_button.text = "LEVEL 3 — LOCKED"
		level3_button.disabled = true


func _on_level1_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(level1)


func _on_level2_pressed():
	if GameProgress.level2_unlocked:
		get_tree().paused = false
		get_tree().change_scene_to_packed(level2)


func _on_level3_pressed():
	if GameProgress.level3_unlocked:
		get_tree().paused = false
		get_tree().change_scene_to_packed(level3)


func _on_back_pressed():
	if opened_from_pause:
		get_parent().get_node("PauseMenu").show()
		queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
