extends State



func on_enter():
	sync_animation("Walk")
	#Logger.log_("Entering Walk state")


func handle_input(_event):
	owner_fsm.rotate_head(_event)


func update(_delta: float):
	owner_fsm.rotate_body(_delta)
	if owner_fsm.player.is_on_floor():
		owner_fsm.player.velocity = owner_fsm.direction * owner_fsm.movement_speed 
		owner_fsm.player.velocity.y = 0

		if Input.is_action_just_pressed("Shift"):
			owner_fsm.emit_signal("transit", "Run")
	if !Input.is_action_pressed("Forward") and !Input.is_action_pressed("Back") and !Input.is_action_pressed("Left") and !Input.is_action_pressed("Right") and !owner_fsm.direction:
		owner_fsm.pop_state()


func on_exit():
	pass
