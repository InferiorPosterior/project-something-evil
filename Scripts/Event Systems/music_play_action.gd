class_name MusicPlayAction extends EventAction

@export var music : AudioStream
# This matches the 'await child.execute()' loop inside your EventArea
func execute() -> void:
	SoundManager.stop_music()
	SoundManager.play_music(music, 5)
