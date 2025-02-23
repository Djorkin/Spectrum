extends Node
class_name UI_Helper

func find_first_button(root_node: Node) -> Button:
	if root_node is Button and root_node.focus_mode != Control.FOCUS_NONE and root_node.visible:
		return root_node
	for child in root_node.get_children():
		if child is Node:
			var found_button = find_first_button(child)
			if found_button != null:
				return found_button
	return null

func set_focus_to_first_button(panel: Node) -> void:
	var first_button = find_first_button(panel)
	if first_button != null:
		first_button.grab_focus()
	else:
		Logger.log_("Первая кнопка не найдена в панели: " + str(panel.name))


func find_panel(panel_name: String, root_node: Node) -> Node:
	if root_node.name == panel_name:
		return root_node
	
	
	var parent_node = root_node.get_parent()
	while parent_node:
		if parent_node.name == panel_name:
			return parent_node
		for sibling in parent_node.get_children():
			if sibling.name == panel_name:
				return sibling
		parent_node = parent_node.get_parent()


	for child in root_node.get_children():
		if child is Node:
			var found_panel = find_panel(panel_name, child)
			if found_panel != null:
				return found_panel
	
	Logger.log_(str("Ошибка: Панель " + panel_name + " не найдена."))
	return null


func get_current_language() -> String:
	return TranslationServer.get_locale()


func change_language(language_code: String, root_node: Node) -> void:
	TranslationServer.set_locale(language_code)
	Logger.log_("Язык изменён на: " + language_code)
	_refresh_all_texts(root_node)


func _refresh_all_texts(root_node: Node) -> void:
	if root_node.has_meta("translation_key"):
		var translation_key = root_node.get_meta("translation_key")
		if root_node is Label or root_node is Button or root_node is RichTextLabel:
			root_node.text = tr(translation_key)
	for child in root_node.get_children():
		_refresh_all_texts(child)


func update_mouse_capture(panel : Node) -> void:
	if panel.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		set_focus_to_first_button(panel)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func update_butt_state(butt: BaseButton, parametr: String, state: bool) -> void:
	match parametr:
		"vis":
			butt.visible = state
		"dis":
			butt.disabled = state
		_:
			Logger.log_("Неизвестный параметр: %s. Поддерживаются только 'vis' и 'dis'." % parametr)
