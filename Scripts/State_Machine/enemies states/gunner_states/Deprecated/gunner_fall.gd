class_name GunnerFall extends State

@onready var enemy: Gunner = get_parent().get_parent()

func physics_update(delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * delta   # keeps its horizontal momentum off a ledge
	enemy.move_and_slide()

	if enemy.is_on_floor():
		Transitioned.emit(self, "gunnerchase")
