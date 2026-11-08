# THIS IS FADE IN SCRIPT
# Black screen that holds for a moment, then fades out to reveal the level.
# Add fade_in.tscn to the level scene. It removes itself when finished.
extends CanvasLayer

@export var hold_time: float = 1.0   # seconds the screen stays fully black
@export var fade_time: float = 0.8   # seconds the fade takes

func _ready() -> void:
	get_tree().paused = true # FREEZES THE LEVEL WHILE BLACK (THIS NODE USES PROCESS MODE "ALWAYS")
	%Overlay.color.a = 1.0
	var tween := create_tween()
	tween.tween_interval(hold_time)
	tween.tween_property(%Overlay, "color:a", 0.0, fade_time)
	tween.finished.connect(_on_finished)

func _input(event: InputEvent) -> void:
	# STOPS ESC FROM OPENING THE PAUSE MENU DURING THE BLACK SCREEN
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()

func _on_finished() -> void:
	get_tree().paused = false
	queue_free()
