extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	# Sets up a permanent music player that survives changing scenes
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

#region MUSIC SYSTEM
# Call from anywhere: SoundManager.play_music(my_track, -6.0)
func play_music(stream: AudioStream, volume_db: float = 0.0, bus_name: String = "Music") -> void:
	if stream == null:
		return
		
	# Automatically tells the file to loop seamlessly at runtime
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		stream.loop = true
	
	# Cuts off the previous song so they don't play on top of each other
	if music_player.playing:
		music_player.stop()
		
	music_player.stream = stream
	music_player.volume_db = volume_db
	music_player.bus = bus_name
	music_player.play()

func stop_music() -> void:
	music_player.stop()
#endregion

#region SOUND EFFECTS SYSTEM
# Call for world sounds: SoundManager.play_sound(laser, global_position)
# Call for UI/Menu sounds: SoundManager.play_sound(click_sound)
func play_sound(stream: AudioStream, pos: Variant = null, volume_db: float = 0.0, pitch_variation: float = 0.0, bus_name: String = "SFX") -> void:
	if stream == null:
		return
		
	var player: Node
	
	if pos is Vector2:
		player = AudioStreamPlayer2D.new()
		player.global_position = pos
	else:
		player = AudioStreamPlayer.new()
		if bus_name == "SFX":
			bus_name = "UI"

	player.stream = stream
	player.bus = bus_name
	
	#  CORRECT: This changes ONLY this specific sound effect instance
	player.volume_db = volume_db
	
	if pitch_variation > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
		
	get_tree().current_scene.add_child(player)
	player.play()
	
	if not player.playing:
		player.queue_free()
		return

	await player.finished
	player.queue_free()

#endregion
