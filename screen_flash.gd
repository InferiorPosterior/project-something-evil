# screen_flash.gd
extends CanvasLayer

@export var color: Color = Color.WHITE
@export var hold_time: float = 0.08        # stays fully white for this long
@export var fade_time: float = 0.7         # then fades out over this long

@onready var rect: ColorRect = $ColorRect

func _ready() -> void:
	rect.color = color
	rect.modulate.a = 1.0                  # fully white on the first frame, so it's immediate
	var tween := create_tween()
	tween.tween_interval(hold_time)
	tween.tween_property(rect, "modulate:a", 0.0, fade_time)
	tween.tween_callback(queue_free)       # removes itself when finished
