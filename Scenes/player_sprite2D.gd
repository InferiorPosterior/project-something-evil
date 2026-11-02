extends AnimatedSprite2D

@onready var player: Player = get_parent()

func _process(_delta: float) -> void:
	var aim := player.get_global_mouse_position().x - player.global_position.x

	# Face the cursor (small dead zone so it doesn't flicker when the cursor is above you)
	if absf(aim) > 4.0:
		flip_h = aim < 0.0

	var wanted := _pick_animation(aim)
	if animation != wanted and sprite_frames.has_animation(wanted):
		play(wanted)

func _pick_animation(aim: float) -> StringName:
	if not player.is_on_floor():
		return &"jump" if player.velocity.y < 0.0 else &"fall"

	if absf(player.velocity.x) < 1.0:
		return &"idle"

	# Moving opposite to where the cursor is = running backwards
	var backward := absf(aim) > 4.0 and signf(player.velocity.x) != signf(aim)
	return &"run_back" if backward else &"run"
