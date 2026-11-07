
extends CanvasLayer

@onready var timer_label: Label = $PanelContainer/TimerLabel

@export var starting_time: float = 300.0

var time_left: float
var timer_finished: bool = false


func _ready() -> void:
	time_left = starting_time
	_update_label()


func _process(delta: float) -> void:
	if timer_finished:
		return

	time_left = maxf(time_left - delta, 0.0)
	_update_label()

	if time_left <= 0.0:
		_on_timer_finished()


func _update_label() -> void:
	if timer_label == null:
		return

	timer_label.text = str(int(ceil(time_left)))


func _on_timer_finished() -> void:
	if timer_finished:
		return

	timer_finished = true
	time_left = 0.0
	_update_label()

	var player := get_tree().get_first_node_in_group("player")

	if not is_instance_valid(player):
		push_error("TimerUI: Player not found!")
		return

	var lives_component := player.get_node_or_null("LivesComponent") as LivesComponent

	if lives_component == null:
		push_error("TimerUI: LivesComponent not found on Player!")
		return

	lives_component.force_game_over()
