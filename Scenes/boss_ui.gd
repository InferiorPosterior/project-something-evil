
extends CanvasLayer

@onready var boss_name: Label = $Control/VBoxContainer/BossName
@onready var health_bar: ProgressBar = $Control/VBoxContainer/HealthBar

var boss_health: HealthComponent
var health_tween: Tween


func _ready() -> void:
	add_to_group("boss_ui")
	layer = 10

	_setup_appearance()


func _setup_appearance() -> void:
	boss_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_name.add_theme_color_override("font_color", Color(0.85, 0.78, 0.61))
	boss_name.add_theme_font_size_override("font_size", 18)

	health_bar.custom_minimum_size = Vector2(500, 18)
	health_bar.show_percentage = false

	var background := StyleBoxFlat.new()
	background.bg_color = Color(0.035, 0.025, 0.02, 0.95)
	background.border_color = Color(0.55, 0.43, 0.25)
	background.set_border_width_all(2)
	health_bar.add_theme_stylebox_override("background", background)

	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.65, 0.035, 0.025)
	fill.set_corner_radius_all(1)
	health_bar.add_theme_stylebox_override("fill", fill)


func set_boss(boss: Node, display_name: String = "") -> void:
	if not is_instance_valid(boss):
		return

	# Find the boss's HealthComponent.
	boss_health = null

	if boss is Enemy:
		boss_health = boss.health

	if boss_health == null:
		boss_health = boss.get_node_or_null("HealthComponent") as HealthComponent

	if boss_health == null:
		push_error("BossUI: Boss HealthComponent not found!")
		return

	boss_name.text = display_name if display_name != "" else boss.name.replace("_", " ").to_upper()

	health_bar.max_value = boss_health.max_health
	health_bar.value = boss_health.current_health

	if not boss_health.current_health_changed.is_connected(_on_health_changed):
		boss_health.current_health_changed.connect(_on_health_changed)

	if not boss_health.max_health_changed.is_connected(_on_max_health_changed):
		boss_health.max_health_changed.connect(_on_max_health_changed)

	if not boss_health.health_depleted.is_connected(_on_boss_defeated):
		boss_health.health_depleted.connect(_on_boss_defeated)

	visible = true
	
	print("BOSS UI CONNECTED TO: ", boss_health.get_parent().name)
	print("BOSS UI INITIAL HP: ", boss_health.current_health)
	print("BOSS UI MAX HP: ", boss_health.max_health)


func _on_health_changed(_difference: int) -> void:
	if not is_instance_valid(boss_health):
		return

	if health_tween and health_tween.is_running():
		health_tween.kill()

	health_tween = create_tween()
	health_tween.tween_property(
		health_bar,
		"value",
		boss_health.current_health,
		0.25
	)
	
	print("BOSS UI RECEIVED HEALTH SIGNAL: ", boss_health.current_health)


func _on_max_health_changed(_difference: int) -> void:
	if is_instance_valid(boss_health):
		health_bar.max_value = boss_health.max_health
		health_bar.value = boss_health.current_health


func _on_boss_defeated() -> void:
	visible = false
