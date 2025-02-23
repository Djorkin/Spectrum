extends State


func on_enter():
	sync_animation("Run")
	#Logger.log_("Entering Run state")

func handle_input(_event):
	owner_fsm.rotate_head(_event)


func update(_delta: float):
	owner_fsm.rotate_body(_delta)
	if owner_fsm.player.is_on_floor():
		owner_fsm.player.velocity = owner_fsm.direction * owner_fsm.movement_speed * owner_fsm.fast_speed_multiplier
		owner_fsm.player.velocity.y = 0

	if !Input.is_action_pressed("Shift") or owner_fsm.direction == Vector3.ZERO:
		#Logger.log_("Run off")
		owner_fsm.pop_state()
	
