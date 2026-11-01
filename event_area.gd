class_name EventArea extends Area2D

signal triggered                    # for one-off hookups in the editor
signal finished

@export var one_shot: bool = true   # untick to let it fire every time the player re-enters
@export var trigger_group: StringName = &"player"

var running: bool = false
var used: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if running or (one_shot and used) or not body.is_in_group(trigger_group):
		return
	run.call_deferred()              # deferred: we're inside a physics callback, and actions spawn physics bodies

func run() -> void:
	running = true
	used = true
	triggered.emit()
	for child in get_children():
		if child is EventAction:
			await child.execute()
	running = false
	finished.emit()
