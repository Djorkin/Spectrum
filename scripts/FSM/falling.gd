extends State



func on_enter():
	#if state_machine_playback:
		#state_machine_playback.travel("Jump")
	#Logger.log_("Entering Fly state")
	pass


func update(_delta):
	owner_fsm.player.velocity.y -= owner_fsm.gravity * _delta
	owner_fsm.player.velocity.x = lerp(owner_fsm.player.velocity.x, 0., 2.0 * _delta)
	owner_fsm.player.velocity.z = lerp(owner_fsm.player.velocity.z, 0., 2.0 * _delta)
	if !owner_fsm.is_falling:
		owner_fsm.pop_state()
