class_name AudioData
extends Resource

@export_category("UI Sounds")
@export var ui_click: AudioStream
@export var ui_submit: AudioStream
@export var ui_fail: AudioStream
@export var ui_close: AudioStream

@export_category("Music")
@export var main_music: AudioStream


func has(key: String) -> bool:
	for property in get_property_list():
		if property.name == key:
			return true
	return false

func get_property(key: String):
	if has(key):
		return get(key)
	return null
