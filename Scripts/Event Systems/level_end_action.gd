class_name LevelEndAction extends EventAction

@export var sound_effect: AudioStream
@export var end_screen: PackedScene                   # drop stage_end_screen.tscn here
@export_file("*.tscn") var next_scene: String         # where Continue goes; leave empty to hide the button
@export var unlock_level_2: bool = true
@export var unlock_level_3: bool = false
@export var delay: float = 1.0                        # a beat between the last enemy dying and the screen appearing

func execute() -> void:
	var timer := get_tree().get_first_node_in_group("level_timer") as TimerLabel
	
	if timer:
		ScoreManager.complete_level(timer.time_left())    # 10 points per second left
		timer.stop()
	SoundManager.play_sound(sound_effect, null)
	
	if unlock_level_2:
		GameProgress.unlock_level2()
		
	if unlock_level_3:
		GameProgress.unlock_level3()

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
		if not is_inside_tree():
			return                                    # the player died during the delay and the level reloaded

	if end_screen == null:
		push_warning("%s: no end_screen assigned" % name)
		return

	var screen := end_screen.instantiate()
	screen.next_scene = next_scene                    # set before add_child, so it's ready when the screen's _ready runs
	get_tree().current_scene.add_child(screen)
