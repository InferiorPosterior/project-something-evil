class_name GrenadierFall extends State

@onready var enemy: Grenadier = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta
	enemy.move_and_slide()

	if enemy.is_on_floor():
		Transitioned.emit(self, "grenadierreposition")
