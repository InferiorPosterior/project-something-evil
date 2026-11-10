extends Node2D

@export var level_music : AudioStream
@export var start_sound: AudioStream

func _ready() -> void:
	# 1. Stop any music playing from previous scenes
	SoundManager.stop_music()
	
	# 2. Both sounds trigger immediately together
	SoundManager.play_sound(start_sound, null, -5)
	SoundManager.play_music(level_music, -5)
