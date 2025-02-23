extends Node

class_name FSM
@warning_ignore("unused_parameter", "unused_signal")
signal transit(new_state)

var state_stack: Array = []
var state_map: Dictionary
var current_state = null

func _ready():
	connect("transit", Callable(self, "_on_transit"))
	init_states()

func init_states():
	state_map = {}
	for child in get_children():
		if child is State:
			state_map[child.name] = child
			child.init(self)

func _on_transit(new_state_name: String):
	if new_state_name in state_map:
		push_state(state_map[new_state_name])

func push_state(new_state):
	if state_stack.size() > 0:
		state_stack[-1].on_exit()
	state_stack.append(new_state)
	new_state.on_enter()

func pop_state():
	if state_stack.size() > 0:
		state_stack.pop_back().on_exit()
		if state_stack.size() > 0:
			state_stack[-1].on_enter()

func update(delta):
	if state_stack.size() > 0:
		state_stack[-1].update(delta)
	#var names = []
	#for element in state_stack:
		#names.append(element.name)
	#Logger.log_(", ".join(names))

func handle_input(event):
	if state_stack.size() > 0:
		state_stack[-1].handle_input(event)
