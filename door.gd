class_name Door extends StaticBody2D

signal finished_moving

@export var start_closed: bool = false
@export var sprite: AnimatedSprite2D            # found automatically if left empty

var is_closed: bool = false
var moving: bool = false

func _ready() -> void:
	if sprite == null:
		for node in find_children("*", "AnimatedSprite2D", true, false):
			sprite = node
			break
	if sprite == null:
		push_warning("%s has no AnimatedSprite2D" % name)
		return
	sprite.animation_finished.connect(_on_animation_finished)

	is_closed = start_closed
	_set_solid(is_closed)
	_show_rest(&"closed" if is_closed else &"open")

func close() -> void:
	if is_closed:
		return
	is_closed = true
	_set_solid(true)                            # solid immediately, so nothing slips through while it closes
	_play_move(&"closing", &"opening")

func open() -> void:
	if not is_closed:
		return
	is_closed = false
	_play_move(&"opening", &"closing")          # passable only once the animation has finished (see below)

# Plays "primary"; if the sprite doesn't have it, plays "fallback" in reverse
# (so a door with only an "opening" animation also closes by playing it backwards)
func _play_move(primary: StringName, fallback: StringName) -> void:
	moving = true
	var frames := sprite.sprite_frames if sprite else null
	if frames and frames.has_animation(primary):
		sprite.play(primary)
	elif frames and frames.has_animation(fallback):
		sprite.play_backwards(fallback)
	else:
		_on_animation_finished.call_deferred()  # no animations at all: just switch state

func _on_animation_finished() -> void:
	if not moving:
		return                                  # a resting animation finished; ignore it
	moving = false
	if is_closed:
		_show_rest(&"closed")
	else:
		_show_rest(&"open")
		_set_solid(false)                       # the passage opens once the door has fully opened
	finished_moving.emit()

# Shows the resting sprite. Uses a "closed" or "open" animation if you made one; otherwise the
# first or last frame of "opening".
func _show_rest(rest: StringName) -> void:
	if sprite == null or sprite.sprite_frames == null:
		return
	var frames := sprite.sprite_frames
	if frames.has_animation(rest):
		sprite.play(rest)
	elif frames.has_animation(&"opening"):
		sprite.animation = &"opening"
		sprite.stop()
		sprite.frame = 0 if rest == &"closed" else frames.get_frame_count(&"opening") - 1

func _set_solid(solid: bool) -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", not solid)
