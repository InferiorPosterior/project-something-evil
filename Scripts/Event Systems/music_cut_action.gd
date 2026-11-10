class_name MusicCutAction extends EventAction

@export var sound_effect : AudioStream
# This matches the 'await child.execute()' loop inside your EventArea
func execute() -> void:
	SoundManager.play_sound(sound_effect, null,-5)
	SoundManager.stop_music()
	print("Music cut action executed from EventArea!")
