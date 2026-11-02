class_name GunnerChase extends EnemyChase

func special_transition(_to_player: Vector2) -> String:
	var gunner := enemy as Gunner
	if gunner.distance_to_player() <= gunner.shoot_enter_range:
		return "gunnershoot"
	return ""
