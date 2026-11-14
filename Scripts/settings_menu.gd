extends Control

# Set to true by the Pause Menu so BACK returns to it.
var opened_from_pause: bool = false

@onready var music_slider: HSlider = %MusicSlider
@onready var music_value: Label = %MusicValue
@onready var sfx_slider: HSlider = %SfxSlider
@onready var sfx_value: Label = %SfxValue
@onready var mode_option: OptionButton = %ModeOption
@onready var back_button: Button = %BackButton


func _ready() -> void:
		# Make the screen fully solid so the menu behind never shows through.
	var bg := get_node_or_null("Background")
	if bg:
		bg.color = Color(0.21, 0.196, 0.21, 1.0)
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.1, 0.1, 0.1, 1.0)
	$CenterContainer/Panel.add_theme_stylebox_override("panel", panel_style)
	
	# Lets the settings screen work while the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS

	mode_option.add_item("WINDOWED")
	mode_option.add_item("FULLSCREEN")

	# Show the current saved values without triggering the signals.
	music_slider.set_value_no_signal(GameSettings.music_volume * 100.0)
	sfx_slider.set_value_no_signal(GameSettings.sfx_volume * 100.0)
	mode_option.select(1 if GameSettings.fullscreen else 0)
	_update_labels()

	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	mode_option.item_selected.connect(_on_mode_selected)
	back_button.pressed.connect(_on_back_pressed)

	music_slider.grab_focus()


func _input(event: InputEvent) -> void:
	# Esc closes the settings. Marking it handled stops the Pause Menu
	# underneath from also reacting to the same key press.
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		_on_back_pressed()


func _on_music_changed(value: float) -> void:
	GameSettings.set_music_volume(value / 100.0)
	_update_labels()


func _on_sfx_changed(value: float) -> void:
	GameSettings.set_sfx_volume(value / 100.0)
	_update_labels()


func _on_mode_selected(index: int) -> void:
	GameSettings.set_fullscreen(index == 1)


func _update_labels() -> void:
	music_value.text = "%d%%" % int(round(music_slider.value))
	sfx_value.text = "%d%%" % int(round(sfx_slider.value))


func _on_back_pressed() -> void:
	GameSettings.save_settings()
	if opened_from_pause:
		var pause_menu := get_parent().get_node_or_null("PauseMenu")
		if pause_menu:
			pause_menu.show()
	queue_free()
