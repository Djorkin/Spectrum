class_name Registrar
extends Node

var saveable_objects: Array = []

func _enter_tree():
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

func _on_node_added(node: Node):
	if node.has_method("get_save_data") and node.has_method("set_save_data"):
		register_object(node)

func _on_node_removed(node: Node):
	unregister_object(node)

func register_object(obj: Node):
	var ref = weakref(obj)
	if not saveable_objects.has(ref):
		saveable_objects.append(ref)

func unregister_object(obj: Node):
	var ref = weakref(obj)
	if saveable_objects.has(ref):
		saveable_objects.erase(ref)

func cleanup_objects():
	saveable_objects = saveable_objects.filter(func(ref): return ref.get_ref() != null)
