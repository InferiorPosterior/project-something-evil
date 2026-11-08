extends Node

# Call this from anywhere in your game: SoundManager.play_sound(my_sound, global_position)
func play_sound(stream: AudioStream, pos: Vector2, volume_db: float = 0.0, pitch_variation: float = 0.0) -> void:
	if stream == null:
		return
		
	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.volume_db = volume_db
	
	if pitch_variation > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
		
	get_tree().current_scene.add_child(player)
	player.global_position = pos
	player.play()
	
	await player.finished
	player.queue_free()
