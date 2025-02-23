extends Node

var DATA: Resource = preload("res://Data/Loader/DATA.tres")
var loaded_obj: Dictionary = {}

func load_(ref: String, allow_multiple: bool = false) -> Node:
	if not allow_multiple and loaded_obj.has(ref):
		return loaded_obj[ref]
	
	if not _has_resource(ref):
		Logger.log_err("Ссылка '%s' не найдена в DATA" % ref)
		return null
	
	var _scene: PackedScene = DATA.get(ref)
	var _instance = _scene.instantiate()
	
	if not allow_multiple:
		loaded_obj[ref] = _instance 
	
	return _instance

func add_(
	ref: String, 
	pos: Vector3 = Vector3.ZERO, 
	allow_multiple: bool = false, 
	custom_key: String = "", 
	object_name: String = "", 
	groups: Array[String] = [],
	parent: Node = get_tree().root
) -> Node:

	var obj = load_(ref, allow_multiple) 
	if obj:
		if object_name:
			if get_tree().root.has_node(object_name):
				Logger.log_warn("Имя '%s' уже занято, генерируем уникальное" % object_name)
				object_name = _generate_unique_name(object_name)
			obj.name = object_name
		else:
			obj.name = _generate_unique_name(ref)
		
		parent.add_child(obj)
		obj.position = pos
		
		for group in groups:
			obj.add_to_group(group)
		
		if custom_key:
			loaded_obj[custom_key] = obj
		elif not allow_multiple:
			loaded_obj[ref] = obj
		
		return obj
	else:
		Logger.log_err("Не удалось добавить объект: " + ref)
		return null


func delete_all_objects():
	for key in loaded_obj:
		var obj = loaded_obj[key]
		_safe_remove_object(obj)
	loaded_obj.clear()
	Logger.log_("Все объекты удалены")

func del_obj(key: String):
	if loaded_obj.has(key):
		var obj = loaded_obj[key]
		_safe_remove_object(obj)
		loaded_obj.erase(key)
		Logger.log_("Объект выгружен: " + key)
	else:
		Logger.log_warn("Объект '%s' не найден" % key)

func get_objects_by_group(group: String) -> Array[Node]:
	return get_tree().get_nodes_in_group(group)

func _has_resource(ref: String) -> bool:
	for property in DATA.get_property_list():
		if property.name == ref:
			var value = DATA.get(ref)
			return value is PackedScene
	return false

func _generate_unique_name(base_name: String) -> String:
	var counter = 1
	var name_ = base_name
	while get_tree().root.has_node(name_):
		name_ = "%s_%d" % [base_name, counter]
		counter += 1
	return name_

func _safe_remove_object(obj: Node):
	if is_instance_valid(obj):
		if obj.is_inside_tree():
			obj.get_parent().remove_child(obj)
		obj.queue_free()
