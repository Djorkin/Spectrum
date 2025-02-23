extends Node


var registrar: Registrar = Registrar.new()
var file_helper: FileHelper = FileHelper.new()
var serializer: Serializer = Serializer.new()


func save_(slot: int) -> bool:
	Logger.log_("Сохраняю...", self)
	registrar.cleanup_objects()
	
	var save_data = {
		"version": "0.2 + RUMI",
		"timestamp": Time.get_datetime_string_from_system(),
		"objects": {}
	}
	
	for ref in registrar.saveable_objects:
		var obj = ref.get_ref()
		if obj and obj.has_method("get_save_data"):
			var data = obj.get_save_data()
			save_data["objects"][obj.get_path()] = serializer.serialize(data)
	
	return file_helper.save_to_file(slot, save_data)


func load_(slot: int) -> bool:
	if !is_multiplayer_authority():
		Logger.log_("Только сервер может инициировать загрузку", self)
		return false
	
	Logger.log_("Загружаю...", self)
	var data = file_helper.load_from_file(slot)
	if data.is_empty():
		return false
	
	_apply_load_data(data)
	
	rpc("apply_client_load", data)
	return true

@rpc("call_remote", "reliable", "any_peer")
func apply_client_load(data: Dictionary):
	if is_multiplayer_authority():
		return
	
	Logger.log_("Получены данные загрузки с сервера", self)
	_apply_load_data(data)

func _apply_load_data(data: Dictionary) -> void:
	for path in data.get("objects", {}):
		var node = get_node_or_null(path)
		if node && node.has_method("set_save_data"):
			var deserialized = serializer.deserialize(data["objects"][path])
			node.set_save_data(deserialized)

func get_slot_metadata(slot: int) -> Dictionary:
	return file_helper.get_metadata(slot)

func has_save(slot: int) -> bool:
	return file_helper.has_save(slot)

func register_object(obj: Node) -> void:
	registrar.register_object(obj)

func unregister_object(obj: Node) -> void:
	registrar.unregister_object(obj)
