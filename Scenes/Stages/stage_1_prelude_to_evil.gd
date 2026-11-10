extends Node2D

@export var level_music : AudioStream
@export var start_sound: AudioStream


#  Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.stop_music()
	await SoundManager.play_sound(start_sound, null, -5)
	SoundManager.play_music(level_music,-5)
