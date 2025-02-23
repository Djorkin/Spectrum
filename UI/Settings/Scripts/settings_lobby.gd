extends MarginContainer


@onready var list_lobby: ItemList = $"../Settings_Net/VBoxContainer2/ScrollContainer/VBoxContainer/VBox_Container/Players/MarginContainer/VBoxContainer/ItemList"
@onready var lobby_waiter_txt: Label = $VBoxContainer2/ScrollContainer/VBoxContainer/VBox_Container/Players/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var lobby_waiter_num: Label = $VBoxContainer2/ScrollContainer/VBoxContainer/VBox_Container/Players/MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var nickname_edit: LineEdit = $VBoxContainer2/ScrollContainer/VBoxContainer/VBox_Container/Name/VBoxContainer2/Name



func _ready() -> void:
	COOP.player_list_updated.connect(_update_lobby)
	_update_lobby({})
	lobby_waiter_txt.text = "Num:"
	load_config_settings()


func _update_lobby(players: Dictionary) -> void:
	list_lobby.clear()
	for player in players.values():
		var player_name = player.get("nick", "Unknown")
		var char_value = player.get("character", "none")
		var char_status = char_value if char_value != "" else "not selected"
		list_lobby.add_item("%s %s" % [player_name, char_status])
	
	var player_count = players.size()
	lobby_waiter_num.text = "%d/%d" % [player_count, COOP.network.MAX_PLAYERS]


func load_config_settings():
	var nick = SettingsConfig.get_value("net", "Name")
	if nick != null and "":
		nickname_edit.text = nick
		Logger.log_("Загружен ник: %s" % nick)


func _on_name_text_submitted(new_text: String) -> void:
	SettingsConfig.set_value("net", "Name", new_text)
	SettingsConfig.save_config()
