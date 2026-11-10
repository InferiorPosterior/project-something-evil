class_name Effect extends Node2D

@export var spawn_sound : AudioStream
@export var sprite_frames: SpriteFrames
@export var animation: StringName = &"default"

# Use get_node_or_null so it won't crash if the node name doesn't match
@onready var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D

func _ready() -> void:
	if sprite == null:
		push_warning("Effect scene is missing an AnimatedSprite2D child node.")
		queue_free()
		return

	# Play the sound immediately upon spawning, independent of animation state
	if spawn_sound:
		SoundManager.play_sound(spawn_sound, null, -3)

	if sprite_frames:
		sprite.sprite_frames = sprite_frames
		
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(animation):
		sprite.sprite_frames.set_animation_loop(animation, false)
		sprite.play(animation)
		await sprite.animation_finished
		
	queue_free()
