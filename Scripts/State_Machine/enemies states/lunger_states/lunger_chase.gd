class_name LungerChase extends EnemyChase

func special_transition(to_player: Vector2) -> String:
	var lunger := enemy as Lunger
	if lunger.dash_cooldown_left <= 0.0 and to_player.length() <= lunger.dash_range:
		return "lungerwindup"
	return ""
