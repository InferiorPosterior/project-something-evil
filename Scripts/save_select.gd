# THIS IS SAVE SELECT SCRIPT
# One scene used for both New Game and Load Game.
# The main menu sets SaveSelect.pending_mode before opening this scene.
# there is no real saving yet. Everything marked PLACEHOLDER is where the save system plugs in later.

# UI ONLY. To finish the save system:
# 1. _get_slot_data(): read the real save file for each slot
# 2. _on_confirm_pressed(): create (NEW) or load (LOAD) the save


class_name SaveSelect extends Control

enum Mode { NEW, LOAD }

const SLOT_COUNT: int = 3
const DIFFICULTY_NAMES: Array[String] = ["EASY", "NORMAL", "HARD"]
# PLACEHOLDER descriptions, edit these once difficulty actually changes something
const DIFFICULTY_INFO: Array[String] = [
	"A relaxed run.",
	"The intended experience.",
	"For players who want a challenge.",
]


# SET BY THE MAIN MENU BEFORE CHANGING TO THIS SCENE
static var pending_mode: Mode = Mode.NEW

# WHAT THE PLAYER PICKED (the game / save system can read these later)
static var current_slot: int = -1
static var current_save_name: String = ""
static var current_difficulty: int = 1 # index into DIFFICULTY_NAMES

var _mode: Mode
var _slot_buttons: Array[Button] = []
var _difficulty_buttons: Array[Button] = []
var _selected_slot: int = -1
var _selected_difficulty: int = 1

func _ready() -> void:
	_mode = pending_mode

	# SLOT BUTTONS (only one can be selected at a time)
	var slot_group := ButtonGroup.new()
	for child in %SlotsBox.get_children():
		if child is Button:
			var index := _slot_buttons.size()
			child.button_group = slot_group
			child.pressed.connect(_on_slot_pressed.bind(index))
			_slot_buttons.append(child)

	# DIFFICULTY BUTTONS (EASY / NORMAL / HARD)
	var difficulty_group := ButtonGroup.new()
	for child in %DifficultyBox.get_children():
		if child is Button:
			var index := _difficulty_buttons.size()
			child.text = DIFFICULTY_NAMES[index]
			child.button_group = difficulty_group
			child.pressed.connect(_on_difficulty_pressed.bind(index))
			_difficulty_buttons.append(child)
	_difficulty_buttons[_selected_difficulty].button_pressed = true
	_update_difficulty_info()

	%BackButton.pressed.connect(_on_back_pressed)
	%ConfirmButton.pressed.connect(_on_confirm_pressed)

	# NEW GAME SHOWS NAME + DIFFICULTY, LOAD GAME HIDES THEM
	%TitleLabel.text = "NEW GAME" if _mode == Mode.NEW else "LOAD GAME"
	%ConfirmButton.text = "START" if _mode == Mode.NEW else "LOAD"
	%NewGameOptions.visible = _mode == Mode.NEW
	%ConfirmButton.disabled = true

	_refresh_slots()

# PLACEHOLDER: replace with real save file reading. Return {} when the slot is empty.
func _get_slot_data(slot: int) -> Dictionary:
	return {}

func _refresh_slots() -> void:
	for i in _slot_buttons.size():
		var data := _get_slot_data(i)
		var button := _slot_buttons[i]
		if data.is_empty():
			button.text = "SLOT %d\nEmpty" % (i + 1)
			button.disabled = _mode == Mode.LOAD # NOTHING TO LOAD FROM AN EMPTY SLOT
		else:
			button.text = "SLOT %d  -  %s\n%s  |  %s" % [i + 1, data["name"], DIFFICULTY_NAMES[data["difficulty"]], data["level"]]
			button.disabled = false

func _on_slot_pressed(index: int) -> void:
	_selected_slot = index
	%ConfirmButton.disabled = false
	%NameEdit.placeholder_text = "Save %d" % (index + 1)

func _on_difficulty_pressed(index: int) -> void:
	_selected_difficulty = index
	_update_difficulty_info()

func _update_difficulty_info() -> void:
	%DifficultyInfo.text = DIFFICULTY_INFO[_selected_difficulty]

func _on_confirm_pressed() -> void:
	current_slot = _selected_slot
	if _mode == Mode.NEW:
		var typed_name: String = %NameEdit.text.strip_edges()
		current_save_name = typed_name if typed_name != "" else "Save %d" % (_selected_slot + 1)
		current_difficulty = _selected_difficulty
		# TODO: create the save file for this slot here
	else:
		# TODO: read the save file for this slot here and apply it
		pass
	# PLACEHOLDER: always starts level 1 for now
	get_tree().change_scene_to_file("res://Scenes/stage_1_prelude_to_evil.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
