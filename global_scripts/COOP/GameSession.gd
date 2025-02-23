class_name GameSession
extends Node



@rpc("authority", "call_local", "reliable")
func start_new_session() -> void:
	GameState.transition_to_phase(GameState.GamePhase.PLAYING)
	Loader.add_("dev_map")  
	_spawn_players()

func _spawn_players():
	Loader.add_("alisa", _get_random_spawn_position(),false)
	Loader.add_("alex", _get_random_spawn_position(),false)
	Loader.add_("shader_cube",_get_random_spawn_position(),false)

func assign_controls(selected_character: String, id: int = 0) -> void:
	var player_id: int = id if id != 0 else multiplayer.get_unique_id()
	var character: Node = Loader.loaded_obj.get(selected_character)
	
	if not character:
		Logger.log_err("Персонаж '%s' не найден!" % selected_character, self)
		return
	
	character.set_multiplayer_authority(player_id)
	character.set_player(player_id)
	
	controls_synx.rpc(selected_character, player_id)


@rpc("any_peer","call_remote", "reliable")
func controls_synx(selected_character: String, id : int):
	var my_player = Loader.loaded_obj.get(selected_character) 
	
	if my_player:
		my_player.set_multiplayer_authority(id)  
		my_player.set_player(id) 
	else:
		Logger.log_err("Персонаж '%s' не найден!" % selected_character, self)


func end_session() -> void:
	GameState.current_mode = GameState.GameMode.NONE
	GameState.current_phase = GameState.GamePhase.NONE
	Loader.delete_all_objects()
	RUMI.switch_to_region("Main_menu")
	RUMI.UI_Help.update_mouse_capture(RUMI.current_region)


func _get_random_spawn_position() -> Vector3:
	var spawn_area_size = Vector3(10, 0, 10)
	var random_x = randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2)
	var random_z = randf_range(-spawn_area_size.z / 2, spawn_area_size.z / 2)
	return Vector3(random_x, 2, random_z)
