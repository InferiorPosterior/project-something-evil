extends Node2D

@export var target: Node2D

func _process(_delta):
	if target:
		# Interpolate towards the player, then round to the nearest whole pixel
		var target_pos = target.global_position
		global_position = target_pos.round() 
