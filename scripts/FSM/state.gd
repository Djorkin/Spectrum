extends Node

class_name State

@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@export var state_machine_playback: AnimationNodeStateMachinePlayback
var owner_fsm: Node = null


func _ready():
	if animation_tree:
		state_machine_playback = animation_tree.get("parameters/StateMachine/playback")
		animation_tree.active = true
	else:
		Logger.log_err("AnimationTree не найден")


func sync_animation(new_state: String):
	if not state_machine_playback:
		Logger.log_err("state_machine_playback не инициализирован")
		return

	if state_machine_playback.get_current_node() == new_state:
		return

	if owner_fsm and owner_fsm.is_multiplayer_authority():
		sync_animation_rpc.rpc(new_state) 
	else:
		sync_animation_rpc(new_state)  


@rpc("any_peer", "call_local", "reliable")
func sync_animation_rpc(new_state: String):
	if state_machine_playback:
		state_machine_playback.travel(new_state)


# Метод для инициализации состояния
func init(obj: Node) -> void:
	owner_fsm = obj


# Пустые методы для переопределения
func on_enter():
	pass

func update(_delta):
	pass

func handle_input(_event):
	pass

func on_exit():
	pass
