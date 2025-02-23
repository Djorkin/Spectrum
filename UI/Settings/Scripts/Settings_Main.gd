extends RUMI_Region


@onready var settings_windows = {
	"gameplay": $Control/MarginContainer/HBoxContainer/Settings_Panel/MarginContainer/Settings_gameplay,
	"controls": $Control/MarginContainer/HBoxContainer/Settings_Panel/MarginContainer/Settings_controls,
	"graphics": $Control/MarginContainer/HBoxContainer/Settings_Panel/MarginContainer/Settings_graphics,
	"experimental": $Control/MarginContainer/HBoxContainer/Settings_Panel/MarginContainer/Settings_exsp,
	"network": $Control/MarginContainer/HBoxContainer/Settings_Panel/MarginContainer/Settings_Net
}


func _ready() -> void:
	hide_all_windows()

func _on_gameplay_button_down() -> void:
	show_window("gameplay")

func _on_graphics_button_down() -> void:
	show_window("graphics")

func _on_controls_button_down() -> void:
	show_window("controls")

func _on_experimental_button_down() -> void:
	show_window("experimental")

func _on_net_button_down() -> void:
	show_window("network")

func hide_all_windows():
	for window in settings_windows.values():
		window.hide()

func show_window(window_name):
	hide_all_windows()
	if settings_windows.has(window_name) and settings_windows[window_name]:
		settings_windows[window_name].show()
