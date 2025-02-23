class_name FileHelper
extends Node

const SAVE_PATH = "user://save_slot_%d.json"

func save_to_file(slot: int, data: Dictionary) -> bool:
	var path = SAVE_PATH % slot
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("Save failed to slot ", slot)
		return false
	
	file.store_string(JSON.stringify(data, "\t"))
	return true

func load_from_file(slot: int) -> Dictionary:
	var path = SAVE_PATH % slot
	if not FileAccess.file_exists(path):
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	
	if error != OK:
		push_error("JSON Error: ", json.get_error_message())
		return {}
	
	return json.data if typeof(json.data) == TYPE_DICTIONARY else {}

func get_metadata(slot: int) -> Dictionary:
	var data = load_from_file(slot)
	return {
		"version": data.get("version", "unknown"),
		"timestamp": data.get("timestamp", "Unknown date")
	} if data else {}

func has_save(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_PATH % slot)
