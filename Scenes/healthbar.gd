class_name HealthBar extends ProgressBar

@export var health: HealthComponent
@export var find_in_group: StringName = &""       # "player" for the HUD, "boss" for a boss bar
@export var hide_until_tracked: bool = false      # useful for boss bars

func _ready() -> void:
	max_value = 100.0
	step = 0.0
	show_percentage = false
	if health == null and find_in_group != &"":
		var node := get_tree().get_first_node_in_group(find_in_group)
		if node:
			health = node.get_node_or_null("HealthComponent")
	if health:
		track(health)
	elif hide_until_tracked:
		hide()

func track(new_health: HealthComponent) -> void:    # also callable for bosses that spawn later
	health = new_health
	health.current_health_changed.connect(_refresh)
	health.max_health_changed.connect(_refresh)
	health.tree_exiting.connect(hide)               # the owner died or was freed
	_refresh.call_deferred(0)                       # HealthComponent fills its values in its own _ready
	show()

func _refresh(_diff: int) -> void:
	if health:
		value = 100.0 * health.current_health / maxf(health.max_health, 1.0)
