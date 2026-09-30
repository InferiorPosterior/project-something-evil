class_name IdleState extends State

@onready var player: CharacterBody2D = get_parent().get_parent()

#override func enter_state() to put what we want the parent to do when entering this state
func enter_state():
	player.velocity.x = 0
	print("Im idling!")
#override update() to put the conditions we want to cause this state to update
