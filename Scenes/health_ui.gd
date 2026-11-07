extends CanvasLayer

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthLabel

var health_component: HealthComponent


func _ready() -> void:
	print("HealthUI loaded!")

	var ancestor = get_parent()

	while ancestor != null:
		var component = ancestor.get_node_or_null("HealthComponent")

		if component is HealthComponent:
			health_component = component
			break

		ancestor = ancestor.get_parent()

	if health_component == null:
		push_error("HealthUI: HealthComponent not found!")
		return

	print("HealthUI connected to: ", health_component.get_parent().name)

	health_component.current_health_changed.connect(_on_current_health_changed)
	health_component.max_health_changed.connect(_on_max_health_changed)

	_update_health_display()


func _on_current_health_changed(_diff: int) -> void:
	print("HEALTH UI RECEIVED: ", health_component.current_health)
	_update_health_display()


func _on_max_health_changed(_diff: int) -> void:
	_update_health_display()


func _update_health_display() -> void:
	if health_component == null:
		return

	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
