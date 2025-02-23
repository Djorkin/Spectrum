extends RUMI_Region

@onready var save_load_label: Label = $"Control/Panel/MarginContainer/VBoxContainer/Save&Load"
@onready var container_slot: VBoxContainer = $Control/Panel/MarginContainer/VBoxContainer/ScrollContainer/Container_slot

@export var slot_scene : PackedScene 

var current_mode: String = "" 

func _ready():
	SignalGlobal.save_mode.connect(_on_save_mode_changed)

func _on_save_mode_changed(mode: String):
	current_mode = mode
	save_load_label.text = mode.capitalize()
	_update_slots()

func _update_slots():
	for child in container_slot.get_children():
		child.queue_free()
	
	var save_files = _get_all_save_files()
	
	for slot in save_files:
		_add_slot(slot, true)
	
	if current_mode == "save":
		_add_slot(save_files.size() + 1, false)

func _add_slot(slot_number: int, exists: bool):
	var slot_instance = slot_scene.instantiate()
	container_slot.add_child(slot_instance)
	
	var button = slot_instance.get_node_or_null("Button") as Button
	
	if not button:
		push_error("Не найден узел Button в сцене слота!")
		return
	
	if exists:
		button.text = "Слот %d" % slot_number
	else:
		button.text = "Новый слот"
	
	button.disabled = false
	button.pressed.connect(_on_slot_selected.bind(slot_number, exists))

func _on_slot_selected(slot: int, exists: bool):
	match current_mode:
		"save":
			if SaveSystem.save_(slot):
				RUMI.hide_overlay_ui()
				_update_slots()
		"load":
			if GameState.current_phase == GameState.GamePhase.LOBBY_CREATE:
				RUMI.switch_to_region.rpc("Choise_menu")
				COOP.start_game()
			if exists and SaveSystem.load_(slot):
				RUMI.hide_overlay_ui()


func _get_all_save_files() -> Array:
	var save_files = []
	var dir = DirAccess.open("user://")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("save_slot_") and file_name.ends_with(".json"):
				var slot = file_name.trim_prefix("save_slot_").trim_suffix(".json").to_int()
				save_files.append(slot)
			file_name = dir.get_next()
	
	save_files.sort()
	return save_files

func _on_close_pressed():
	RUMI.hide_overlay_ui()
