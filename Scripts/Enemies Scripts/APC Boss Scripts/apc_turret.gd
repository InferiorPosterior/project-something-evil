class_name ApcTurret extends Node2D

@export var autocannon: AmmoWeapon
@export var missile_pod: AmmoWeapon
@export var swap_delay: float = 1.0            # pause between the two weapons

func _ready() -> void:
	autocannon.depleted.connect(_swap_to.bind(missile_pod))
	missile_pod.depleted.connect(_swap_to.bind(autocannon))
	autocannon.enable()                        # defaults to the autocannon

func _swap_to(next: AmmoWeapon) -> void:
	# connected through a Callable on this node, so it can't fire after the APC is destroyed
	get_tree().create_timer(swap_delay).timeout.connect(next.enable)
