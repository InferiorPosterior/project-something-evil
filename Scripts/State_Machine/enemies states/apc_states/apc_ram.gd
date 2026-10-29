class_name ApcRam extends State

@export var windup_time: float = 0.6          # revs up, still turning to face you
@export var ram_speed: float = 260.0
@export var ram_accel: float = 300.0          # builds up speed gradually
@export var ram_time: float = 1.4
@export var brake: float = 400.0              # slows down after the charge
@export var recover_time: float = 1.0
@export var cooldown: float = 3.0             # before it may ram again

enum Phase { WINDUP, CHARGE, RECOVER }

@onready var apc: Apc = get_parent().get_parent()
var phase: Phase = Phase.WINDUP
var timer: float = 0.0

func enter_state() -> void:
	phase = Phase.WINDUP
	timer = windup_time

func physics_update(delta: float) -> void:
	apc.apply_gravity(delta)
	timer -= delta

	match phase:
		Phase.WINDUP:
			apc.face_player()
			apc.velocity.x = move_toward(apc.velocity.x, 0.0, brake * delta)
			if timer <= 0.0:
				phase = Phase.CHARGE           # direction is locked from here
				timer = ram_time
		Phase.CHARGE:
			apc.velocity.x = move_toward(apc.velocity.x, apc.facing * ram_speed, ram_accel * delta)
			if timer <= 0.0 or apc.is_on_wall():
				phase = Phase.RECOVER
				timer = recover_time
				apc.ram_cooldown_left = cooldown
		Phase.RECOVER:
			apc.velocity.x = move_toward(apc.velocity.x, 0.0, brake * delta)
			if timer <= 0.0:
				Transitioned.emit(self, "apcmove")
				return

	apc.move_and_slide()
