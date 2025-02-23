class_name UIAnimator

static func play(node: Node, anim_name: String, duration: float = 0.5) -> void:
	var transition = preload("res://UI/Animation/base/Transition_screen.tscn").instantiate()
	node.call_deferred("add_child",transition)
	await transition.play_animation(anim_name, duration)
