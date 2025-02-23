extends RUMI_Region

@onready var list_lobby: ItemList = $Control/Players/MarginContainer/VBoxContainer/ItemList
@onready var lobby_waiter_txt: Label = $Control/Players/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var lobby_waiter_num: Label = $Control/Players/MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var start_button: Button = $Control/Players/MarginContainer/VBoxContainer/START
@onready var load_button: Button = $Control/Players/MarginContainer/VBoxContainer/Load

func _ready() -> void:
	COOP.player_list_updated.connect(_update_lobby)
	_update_lobby({})

func on_hide() -> void:
	super.on_hide()

func _on_start_button_down() -> void:
	COOP.start_game()
	RUMI.switch_to_region.rpc("Choise_menu")

func _on_load_button_down() -> void:
	SignalGlobal.save_mode.emit("load")
	RUMI.overlay_ui("Saves_UI")

func _update_lobby(players: Dictionary) -> void:
	list_lobby.clear()
	for player in players.values():
		var player_name = player.get("nick", "Unknown")
		var char_value = player.get("character", "none")
		var char_status = char_value if char_value != "" else "not selected"
		list_lobby.add_item("%s (%s)" % [player_name, char_status])
	
	var player_count = players.size()
	var is_full = player_count >= COOP.network.MAX_PLAYERS
	lobby_waiter_txt.text = "Ready" if is_full else "Awaiting..."
	lobby_waiter_num.text = "%d/%d" % [player_count, COOP.network.MAX_PLAYERS]
	start_button.disabled = !is_full
	start_button.disabled = !is_full || !multiplayer.is_server()
	load_button.disabled = !is_full || !multiplayer.is_server()
	start_button.visible = multiplayer.is_server()
	load_button.visible = multiplayer.is_server()
