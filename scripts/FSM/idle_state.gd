extends State


func on_enter():
	sync_animation("Idle")
	#Logger.log_("Entering Idle state")


func handle_input(_event):
	owner_fsm.rotate_head(_event)


func update(_delta):
	if !owner_fsm.is_falling:
		owner_fsm.player.velocity = owner_fsm.direction * owner_fsm.movement_speed 
		owner_fsm.player.velocity.y = 0

	if owner_fsm.direction:
		owner_fsm.emit_signal("transit", "Walk")
