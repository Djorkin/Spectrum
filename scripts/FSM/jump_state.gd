extends State


func _ready():
	super._ready()
	animation_tree.connect("animation_finished", Callable(self, "_on_animation_finished"))


func on_enter():
	sync_animation("Jump")
	owner_fsm.player.velocity.y = 3
	#Logger.log_("Entering Jump state")


func handle_input(_event):
	owner_fsm.rotate_head(_event)


func update(_delta: float):
	owner_fsm.rotate_body(_delta)
	if owner_fsm.player.is_on_floor():
		owner_fsm.pop_state()

#
#func _on_animation_finished(anim_name):
	#if anim_name == "Jump":
		#Logger.log_("Jump animation finished")
		#owner_fsm.pop_state()
