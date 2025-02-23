extends Node

signal player_list_updated(players: Dictionary)

var network := NetworkManager.new()
var game_session := GameSession.new()
var players: Dictionary = {}

func _ready() -> void:
	network.players_updated.connect(_on_players_updated)
	network.connection_success.connect(client_connect)
	network.connection_failed.connect(client_connect_fail)
	
	network.name = "net"
	game_session.name = "game_"
	
	add_child(network)
	add_child(game_session)

func host_game() -> bool:
	GameState.transition_to_phase(GameState.GamePhase.LOBBY_CREATE)
	return network.host_game()

func join_game(ip: String) -> bool:
	GameState.transition_to_phase(GameState.GamePhase.LOBBY_CREATE)
	return network.join_game(ip)

func get_players() -> Dictionary:
	return players.duplicate(true)

func start_game() -> void:
	if multiplayer.is_server():
		game_session.rpc("start_new_session")

func get_player_name(player_id: int) -> String:
	return players.get(player_id, {}).get("nick", "Unknown")

func _on_players_updated(_players: Dictionary) -> void:
	players = _players
	player_list_updated.emit(_players)

func select_character(character: String):
	network.select_character(character)
	game_session.assign_controls(character)

func end_session():
	game_session.end_session()
	network.reset_connection()

func client_connect():
	RUMI.switch_to_region("Lobby_UI")

func client_connect_fail():
	RUMI.switch_to_region("Connect_UI")
