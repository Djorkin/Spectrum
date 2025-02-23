extends Node

@onready var move_f_but: Button = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer/move/VBoxContainer2/Move_F
@onready var move_b_but: Button = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer2/move2/VBoxContainer2/Move_B
@onready var move_r_but: Button = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer3/move3/VBoxContainer2/Move_R
@onready var move_l_but: Button = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer4/move4/VBoxContainer2/Move_L
@onready var jump_but: Button = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer5/move4/VBoxContainer2/Jump
@onready var m_sense_slider: HSlider = $VBoxContainer2/ScrollContainer/VBoxContainer/MarginContainer/VBox_Container/PanelContainer6/Res_Box2/VBoxContainer2/MarginContainer/m_sense


@onready var warning_timer: Timer = $"../../../../../../warning_timer"
@onready var input_waiter: Panel = $Input_waiter
@onready var warn_label: Label = $VBoxContainer2/Warn


var current_key_action: String = ""
var is_waiting_for_key: bool = false

func _ready() -> void:
	warn_label.hide()
	apply_controls_settings()
	load_all_settings()


func load_all_settings() -> void:
	m_sense_slider.value = SettingsConfig.get_value("controls", "m_sense")
	
	for action in InputMap.get_actions():
		update_button_label(action)

func get_button_by_action(action: String) -> Button:
	match action:
		"Forward": 
			return move_f_but
		"Back": 
			return move_b_but
		"Right": 
			return move_r_but
		"Left": 
			return move_l_but
		"Jump": 
			return jump_but
		# Если добавите новые кнопки, добавьте их сюда
	return null

func is_system_key(scancode: int) -> bool:
	var system_keys = [
		KEY_ESCAPE, 
		KEY_CTRL, 
		KEY_SHIFT, 
		KEY_ALT, 
		KEY_CAPSLOCK,
		KEY_NUMLOCK, 
		KEY_SCROLLLOCK
	]
	return scancode in system_keys

func update_button_label(action: String) -> void:
	var event = get_first_event_for_action(action)
	var button = get_button_by_action(action)
	if button:
		if event is InputEventKey:
			button.text = OS.get_keycode_string(event.keycode)
		else:
			button.text = "None"

func get_first_event_for_action(action: String) -> InputEvent:
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		return events[0]
	return null

func waiting_rebild(action: String) -> void:
	current_key_action = action
	is_waiting_for_key = true
	input_waiter.show()

func _input(event: InputEvent) -> void:
	if is_waiting_for_key and event is InputEventKey and event.pressed:
		var scancode = event.keycode
	
		if is_system_key(scancode):
			show_warning_message("Попытка привязать системную клавишу '%s' была отклонена." % [OS.get_keycode_string(scancode)])
			return
	
		is_waiting_for_key = false
		input_waiter.hide()
		SettingsConfig.set_value("controls", current_key_action, scancode)
	
		reset_action_bindings(current_key_action)
		add_action_binding(current_key_action, scancode)
		update_button_label(current_key_action)
	
	
		Logger.log_("Клавиша для '%s' изменена на '%s'." % [current_key_action, OS.get_keycode_string(scancode)])


func reset_action_bindings(action: String) -> void:
	m_sense_slider.value = SettingsConfig.get_value("controls", "m_sense", 0.1)
	
	var events = InputMap.action_get_events(action)
	for event in events:
		InputMap.action_erase_event(action, event)

func add_action_binding(action: String, key_code: int) -> void:
	remove_existing_binding(key_code)
	var key_event = InputEventKey.new()
	key_event.keycode = key_code
	InputMap.action_add_event(action, key_event)
	Logger.log_("Клавиша '%s' добавлена к действию '%s'." % [OS.get_keycode_string(key_code), action])

func apply_controls_settings() -> void:
	for action in InputMap.get_actions():
		var key_code = SettingsConfig.get_value("controls", action, null)
		if key_code != null:
			reset_action_bindings(action)
			add_action_binding(action, key_code)

func remove_existing_binding(key_code: int) -> void:
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		for event in events:
			if event is InputEventKey and event.keycode == key_code:
				InputMap.action_erase_event(action, event)
				show_warning_message("Клавиша '%s' была удалена из действия '%s'." % [OS.get_keycode_string(key_code), action])
				update_button_label(action)

func show_warning_message(message: String) -> void:
	warn_label.text = message
	warn_label.visible = true
	warning_timer.start(2.0)

func _on_warning_timer_timeout() -> void:
	warn_label.visible = false

func _on_save_button_down() -> void:
	SettingsConfig.save_config()
	Logger.log_("Настройки сохранены.")

func _on_res_button_down() -> void:
	SettingsConfig.set_default_config("controls")
	apply_controls_settings()
	load_all_settings()
	Logger.log_("Настройки сброшены к значениям по умолчанию.")


func _on_move_f_button_down() -> void:
	waiting_rebild("Forward")


func _on_move_b_button_down() -> void:
	waiting_rebild("Back")


func _on_move_r_button_down() -> void:
	waiting_rebild("Right")


func _on_move_l_button_down() -> void:
	waiting_rebild("Left")


func _on_jump_button_down() -> void:
	waiting_rebild("Jump")


func _on_m_sense_value_changed(value: float) -> void:
	SignalGlobal.m_sense_change.emit()
	SettingsConfig.set_value("controls", "m_sense", value)
	show_warning_message("Чувствительность мыши изменена: %.2f" % value)
	Logger.log_("Чувствительность мыши изменена: %.2f" % value, self)
