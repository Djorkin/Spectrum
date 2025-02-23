extends RUMI_Region

@onready var alex: Button = $Control/Choise_Player/MarginContainer/VBoxContainer/HBoxContainer/Panel/ALEX
@onready var alisa: Button = $Control/Choise_Player/MarginContainer/VBoxContainer/HBoxContainer/Panel2/ALISA


@onready var UI_helper = UI_Helper.new()

func _ready() -> void:
	COOP.network.update_lobby_event.connect(update_buttons)

func update_buttons() -> void:
	if multiplayer.multiplayer_peer == null:
		btn_state()
	if multiplayer.multiplayer_peer != null:
		btn_state.rpc()

@rpc("any_peer", "call_local", "reliable")
func btn_state():
	var selected_chars = COOP.network.selected_characters.values()
	
	alex.disabled = "alex" in selected_chars
	alisa.disabled = "alisa" in selected_chars
	
	Logger.log_("Кнопки обновлены. Выбранные персонажи: %s" % str(selected_chars))

func _on_alex_button_down() -> void:
	COOP.select_character("alex")
	go()

func _on_alisa_button_down() -> void:
	COOP.select_character("alisa")
	go()

func go():
	GameState.transition_to_phase(GameState.GamePhase.PLAYING)
	self.on_hide()
	UI_helper.update_mouse_capture(self)
	UIAnimator.play(self, "dissolve", 3)
