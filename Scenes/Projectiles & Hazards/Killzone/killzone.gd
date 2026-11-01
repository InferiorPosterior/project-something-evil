class_name Killzone extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	var health := _find_health(body)
	if health == null:
		return
	health.immortality = false   # bypass i-frames
	health.current_health = 0    # emits health_depleted

func _find_health(node: Node) -> HealthComponent:
	for child in node.get_children():
		if child is HealthComponent:
			return child
	return null
