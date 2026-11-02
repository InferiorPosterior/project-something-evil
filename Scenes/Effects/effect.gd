class_name Effect extends Node2D

@export var sprite_frames: SpriteFrames          ## leave empty for a sound-only effect
@export var animation: StringName = &"default"
@export var sound: AudioStream                   ## leave empty for an animation-only effect
@export var volume_db: float = 0.0
@export var pitch_variation: float = 0.0         ## 0.1 = random pitch within ±10%

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	# Animation
	if sprite_frames:
		sprite.sprite_frames = sprite_frames
	var has_anim := sprite.sprite_frames != null and sprite.sprite_frames.has_animation(animation)
	if has_anim:
		sprite.sprite_frames.set_animation_loop(animation, false)   # looping never finishes
		sprite.play(animation)
	else:
		sprite.hide()

	# Sound
	if sound:
		audio.stream = sound
		audio.volume_db = volume_db
		if pitch_variation > 0.0:
			audio.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
		audio.play()

	# Wait for whichever lasts longer, then free everything together
	if has_anim:
		await sprite.animation_finished
		sprite.hide()
	if audio.playing:
		await audio.finished
	queue_free()
