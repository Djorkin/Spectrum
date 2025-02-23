extends RUMI_Region


@onready var buttons_container = $Control/VBoxContainer


func _ready() -> void:
	GameState.game_phase_changed.connect(_update_buttons)
	_update_buttons()
	reg_command()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and self.visible == false:
		_on_back_pressed()
		if RUMI.has_active_overlay():
			RUMI.hide_overlay_ui()

func _on_create_game_button_down() -> void:
	COOP.host_game()
	if SettingsConfig.get_value("net", "Name") != "" or null:
		RUMI.switch_to_region("Lobby_UI") 
	else: 
		RUMI.switch_to_region("Change_name_UI") 

func _on_connect_button_down() -> void:
	if SettingsConfig.get_value("net", "Name") != "" or null:
		RUMI.switch_to_region("Connect_UI")  
	else: 
		RUMI.switch_to_region("Change_name_UI") 

func _on_continue_button_down() -> void:
	if GameState.GamePhase.LOBBY_CREATE:
		RUMI.switch_to_region("Lobby_UI")
	visible = false
	UI_Help.update_mouse_capture(self)

func _on_save_pressed() -> void:
	RUMI.overlay_ui("Saves_UI")
	SignalGlobal.save_mode.emit("save")

func _on_load_pressed() -> void:
	RUMI.overlay_ui("Saves_UI")
	SignalGlobal.save_mode.emit("load")

func _on_settings_button_down() -> void:
	RUMI.switch_to_region("Settings")

func _on_exit_to_menu_button_down() -> void:
	RUMI.switch_to_region("Main_menu")
	COOP.end_session()

func _on_exit_pressed() -> void:
	Logger.txt_log("Выход")
	get_tree().quit()

func reg_command():
	Logger.register_command("start_game", Callable(self, "_on_new_game_button_down"))
	Logger.register_command("quit", Callable(self, "_on_exit_pressed"))

func _update_buttons(phase = GameState.GamePhase.NONE) -> void:
	_set_button_visibility("CONTINUE", phase in [1, 2])
	_set_button_visibility("Save", phase == 2)
	_set_button_visibility("Load", phase == 2 and multiplayer.is_server())
	_set_button_visibility("EXIT_TO_MENU", phase in [1, 2])
	_set_button_visibility("EXIT", phase == 0)
	_set_button_visibility("Create_Game", phase == 0)
	_set_button_visibility("Connect", phase == 0)

func _set_button_visibility(button_name: String, state: bool) -> void:
	var button = buttons_container.get_node(button_name)
	if button:
		UI_Help.update_butt_state(button, "vis", state)
