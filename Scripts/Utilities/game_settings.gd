extends Node
# Autoload: "GameSettings"
# Holds the player's audio and display settings, applies them,
# and saves them to user://settings.cfg so they are remembered.

const SAVE_PATH := "user://settings.cfg"

const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"
const UI_BUS := "UI"

# 0.0 = silent, 1.0 = maximum = the volume the game already had.
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var fullscreen: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_create_buses()
	load_settings()
	apply_all()


# SoundManager already plays sounds on the buses "Music", "SFX" and "UI",
# but those buses do not exist in the project yet, so they are made here.
# UI sounds are sent through the SFX bus so one slider controls both.
func _create_buses() -> void:
	_ensure_bus(MUSIC_BUS, "Master")
	_ensure_bus(SFX_BUS, "Master")
	_ensure_bus(UI_BUS, SFX_BUS)


func _ensure_bus(bus_name: String, send_to: String) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		AudioServer.add_bus()
		idx = AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, bus_name)
	AudioServer.set_bus_send(idx, send_to)


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_apply_bus_volume(MUSIC_BUS, music_volume)


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_apply_bus_volume(SFX_BUS, sfx_volume)


func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	_apply_display()


func apply_all() -> void:
	_apply_bus_volume(MUSIC_BUS, music_volume)
	_apply_bus_volume(SFX_BUS, sfx_volume)
	_apply_display()


func _apply_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	# linear 1.0 gives 0 dB, so maximum volume = the game's normal volume.
	AudioServer.set_bus_mute(idx, linear <= 0.0)
	AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(linear, 0.0001)))


func _apply_display() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.save(SAVE_PATH)


func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return # first run: keep the defaults
	music_volume = clampf(float(config.get_value("audio", "music_volume", 1.0)), 0.0, 1.0)
	sfx_volume = clampf(float(config.get_value("audio", "sfx_volume", 1.0)), 0.0, 1.0)
	fullscreen = bool(config.get_value("display", "fullscreen", false))
