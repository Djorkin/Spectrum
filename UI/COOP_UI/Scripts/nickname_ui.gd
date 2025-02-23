extends RUMI_Region


@onready var nick_name: LineEdit = $Control/Name_panel/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/Nick_Name



func _on_ok_button_down() -> void:
	SettingsConfig.set_value("net", "Name", nick_name.text)
	SettingsConfig.save_config()
	if multiplayer.is_server():
		RUMI.switch_to_region("Lobby_UI")
		
	else:
		RUMI.switch_to_region("Connect_UI")
