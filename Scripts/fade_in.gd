extends CanvasLayer

@export var pause_duration: float = 0.5  # seconds the game stays frozen/black independently
@export var fade_time: float = 0.8       # seconds the fade-out takes

func _ready() -> void:
	get_tree().paused = true # Freezes the level
	
	%Overlay.color.a = 1.0
	%StageLabel.modulate.a = 1.0
	
	var tween := create_tween()
	
	# 1. Hold the pause for your exported pause duration
	tween.tween_interval(pause_duration)
	
	# 2. Unpause the game right before the fade starts
	tween.tween_callback(func(): get_tree().paused = false)
	
	# 3. Fade out both the overlay and the label together
	tween.set_parallel(true)
	tween.tween_property(%Overlay, "color:a", 0.0, fade_time)
	tween.tween_property(%StageLabel, "modulate:a", 0.0, fade_time)
	
	# 4. Clean up the node when finished
	tween.chain().tween_callback(queue_free)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
