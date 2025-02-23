extends Node

enum GameMode {NONE, SINGLEPLAYER, MULTIPLAYER}
enum GamePhase {NONE, LOBBY_CREATE, PLAYING}

signal game_mode_changed(new_mode)
signal game_phase_changed(new_phase)



var mode_transitions = {
	GameMode.NONE: [GameMode.SINGLEPLAYER, GameMode.MULTIPLAYER],
	GameMode.SINGLEPLAYER: [GameMode.NONE],
	GameMode.MULTIPLAYER: [GameMode.NONE]
}

var phase_transitions = {
	GamePhase.NONE: [GamePhase.LOBBY_CREATE],
	GamePhase.LOBBY_CREATE: [GamePhase.PLAYING, GamePhase.NONE],
	GamePhase.PLAYING: [GamePhase.NONE]
}

var current_mode: GameMode = GameMode.NONE:
	set(value):
		if value != current_mode and _is_valid_mode_transition(value):
			current_mode = value
			game_mode_changed.emit(value)
			_handle_mode_change(value)

var current_phase: GamePhase = GamePhase.NONE:
	set(value):
		if value != current_phase and _is_valid_phase_transition(value):
			current_phase = value
			game_phase_changed.emit(value)
			_handle_phase_change(value)

func initialize_game(mode: GameMode, phase: GamePhase = GamePhase.NONE) -> void:
	current_mode = mode
	current_phase = phase

func transition_to_mode(new_mode: GameMode) -> bool:
	if _is_valid_mode_transition(new_mode):
		current_mode = new_mode
		return true
	return false

func transition_to_phase(new_phase: GamePhase) -> bool:
	if _is_valid_phase_transition(new_phase):
		current_phase = new_phase
		return true
	return false

func _is_valid_mode_transition(new_mode: GameMode) -> bool:
	return new_mode in mode_transitions.get(current_mode, [])

func _is_valid_phase_transition(new_phase: GamePhase) -> bool:
	return new_phase in phase_transitions.get(current_phase, [])

func _handle_mode_change(new_mode: GameMode) -> void:
	match new_mode:
		GameMode.MULTIPLAYER:
			Logger.log_("Инициализация мультиплеера", self)
		GameMode.SINGLEPLAYER:
			Logger.log_("Загрузка одиночной кампании", self)

func _handle_phase_change(new_phase: GamePhase) -> void:
	match new_phase:
		GamePhase.LOBBY_CREATE:
			Logger.log_("Создание лобби", self)
		GamePhase.PLAYING:
			Logger.log_("Старт игрового процесса", self)
		GamePhase.NONE:
			Logger.log_("Выход в главное меню", self)

# Пример использования:
# Game.transition_to_mode(Game.GameMode.MULTIPLAYER)
# Game.transition_to_phase(Game.GamePhase.LOBBY_CREATE)
