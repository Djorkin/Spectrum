class_name NetworkManager
extends Node

signal players_updated
signal connection_success
signal connection_failed
signal update_lobby_event

const PORT: int = 9080
const MAX_PLAYERS: int = 2

var players := {}
var selected_characters := {}
var peer := ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func host_game() -> bool:
	reset_connection()
	if peer.create_server(PORT) != OK:
		Logger.log_err("Не удалось создать сервер", self)
		return false
	multiplayer.multiplayer_peer = peer
	_add_player(multiplayer.get_unique_id())
	Logger.log_("Сервер запущен", self)
	GameState.transition_to_mode(GameState.GameMode.MULTIPLAYER)
	return true

func join_game(ip: String) -> bool:
	if peer.create_client(ip, PORT) != OK:
		Logger.log_err("Ошибка подключения", self)
		return false
	multiplayer.multiplayer_peer = peer
	return true

func _add_player(id: int) -> void:
	var nick = SettingsConfig.get_value("net", "Name", "Игрок%d" % id)
	players[id] = {
		"nick": nick,
		"character": ""
	}
	Logger.log_("Игрок '%s' (ID: %d) добавлен в игру." % [nick, id], self)
	players_updated.emit(players)

	if multiplayer.is_server():
		rpc("update_players", players)

func _remove_player(id: int) -> void:
	var player_nick = players.get(id, {}).get("nick", "Неизвестный")
	players.erase(id)
	Logger.log_("Игрок '%s' (ID: %d) удален из игры." % [player_nick, id], self)
	players_updated.emit(players)
	
	if multiplayer.is_server() and players.is_empty():
		reset_connection()
	
	if multiplayer.is_server():
		rpc("update_players", players)

func reset_connection():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

	players.clear()
	selected_characters.clear()
	update_lobby_event.emit()
	Logger.log_("Соединение полностью сброшено", self)


#region Lobby

@rpc("call_local", "reliable")
func update_players(players_data: Dictionary) -> void:
	players = players_data
	
	for id in players:
		var char_name = players[id].get("character", "")
		if char_name != selected_characters.get(id, ""):
			selected_characters[id] = char_name
	
	Logger.log_("Обновлены персонажи: %s" % str(selected_characters), self)
	players_updated.emit(players)

@rpc("any_peer", "reliable")
func request_sync_lobby(requester_id: int):
	Logger.log_("Запрос синхронизации от игрока с ID %d." % requester_id, self)
	rpc_id(requester_id, "update_players", players)

func select_character(character: String):
	var my_id = multiplayer.get_unique_id()
	if multiplayer.is_server():
		_set_character(my_id, character)
	else:
		rpc_id(1, "_request_character_change", character)

@rpc("any_peer", "reliable")
func _request_character_change(character: String):
	var sender_id = multiplayer.get_remote_sender_id()
	_set_character(sender_id, character)

func _set_character(player_id: int, character: String):
	if player_id == null or character == null:
		return
	
	if players.has(player_id):
		players[player_id]["character"] = character
		if multiplayer.is_server():
			rpc("update_players", players)
		update_lobby_event.emit()
		Logger.log_("Игрок %d выбрал персонажа: %s" % [player_id, character], self)

#endregion Lobby

#region Signal

func _on_peer_connected(id: int) -> void:
	if players.size() < MAX_PLAYERS:
		Logger.log_("Подключился игрок с ID %d. Добавляем в список." % id, self)
		_add_player(id)
		if GameState.current_phase == GameState.GamePhase.PLAYING:
			rpc("reconnect_")
	else:
		Logger.log_warn("Игрок с ID %d попытался подключиться, но лобби переполнено." % id, self)
		peer.disconnect_peer(id)

func _on_peer_disconnected(id: int) -> void:
	if multiplayer.is_server() and not players.is_empty():
		var char_name = players[id].get("character", "")
		Logger.log_warn("Сброс управления для %s" % char_name, self)
		COOP.game_session.assign_controls(char_name, -1)
		_remove_player(id)
	Logger.log_("Игрок с ID %d отключился." % id, self)

func _on_connected_to_server() -> void:
	Logger.log_("Успешное подключение к серверу.", self)
	connection_success.emit()
	rpc_id(1, "request_sync_lobby", multiplayer.get_unique_id())

func _on_server_disconnected():
	Logger.log_err("Соединение с сервером потеряно!", self)
	COOP.end_session()

func _on_connection_failed() -> void:
	Logger.log_err("Не удалось подключиться к серверу.", self)
	connection_failed.emit()

#endregion Signal

@rpc("call_remote", "reliable")
func reconnect_(): 
	Logger.log_warn("Обновляю состояние игры: %s" % GameState.current_phase) 
	if GameState.current_phase == GameState.GamePhase.LOBBY_CREATE:
		COOP.game_session.start_new_session()
		synx_char()
		RUMI.switch_to_region("Choise_menu")
	else: 
		Logger.log_err("Состояние игры не обновлено") 

func synx_char():
	for id in players:
		var character_name  = players[id].get("character", "")
		COOP.game_session.assign_controls(character_name, id)
		_set_character(id, character_name)
		Logger.log_("Игрок с ID %s выбрал персонажа: %s" % [id, character_name])
