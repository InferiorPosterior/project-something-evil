# timer_label.gd  (attach to TimerLabel)
class_name TimerLabel extends Label

signal time_up

@export var limit: float = 300.0                   # seconds; set per stage in the Inspector
@export var force_game_over_on_timeout: bool = true
@export var warning_time: float = 30.0             # turns red below this

var _timer := Timer.new()

func _ready() -> void:
	add_to_group("level_timer")
	_timer.one_shot = true
	_timer.wait_time = limit
	_timer.timeout.connect(_on_timeout)
	add_child(_timer)                              # a child Timer pauses with the game, so the pause menu stops it
	_timer.start()

func _process(_delta: float) -> void:
	var seconds := ceili(_timer.time_left)
	text = "%d:%02d" % [floori(seconds / 60.0), seconds % 60]
	modulate = Color.RED if _timer.time_left <= warning_time else Color.WHITE

func time_left() -> float:
	return _timer.time_left

func stop() -> void:
	_timer.stop()

func _on_timeout() -> void:
	time_up.emit()
	if not force_game_over_on_timeout:
		return
	var player := get_tree().get_first_node_in_group("player")
	var lives := player.get_node_or_null("LivesComponent") as LivesComponent if player else null
	if lives:
		lives.force_game_over()                    # from his patch
