
extends CanvasLayer

@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var health_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HealthLabel

var health_component: HealthComponent


func _ready() -> void:
	var player = get_parent()

	if player == null:
		push_error("HealthUI: Player not found.")
		return

	health_component = player.get_node_or_null(
		"HealthComponent"
	) as HealthComponent

	if health_component == null:
		push_error("HealthUI: HealthComponent not found under Player.")
		return

	health_component.current_health_changed.connect(
		_on_current_health_changed
	)
	health_component.max_health_changed.connect(
		_on_max_health_changed
	)

	_update_health_display()


func _on_current_health_changed(_diff: int) -> void:
	_update_health_display()


func _on_max_health_changed(_diff: int) -> void:
	_update_health_display()


func _update_health_display() -> void:
	if health_component == null:
		return

	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health

	health_label.text = "VITALITY  %d / %d" % [
		health_component.current_health,
		health_component.max_health
	]
