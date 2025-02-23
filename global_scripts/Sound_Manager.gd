extends Node


const MAX_SFX_PLAYERS = 8 

var audio_data: AudioData
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var sounds: Dictionary = {}
var music_volume_db: float = 0.0
var sfx_volume_db: float = 0.0

func _ready():
	audio_data = preload("res://Data/audio/Audio.tres")
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	for i in MAX_SFX_PLAYERS:
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players.append(player)

func play_music(music_key: String):
	if not audio_data.has(music_key):
		push_error("Музыка не найдена: " + music_key)
		return
	
	var stream = audio_data.get(music_key)
	if stream is AudioStream:
		music_player.stream = stream
		music_player.play()
	else:
		push_error("Ресурс не является AudioStream: " + music_key)

func play_sfx(sfx_key: String):
	var free_player = _get_free_player()
	if not free_player:
		return
	
	if not audio_data.has(sfx_key):
		push_error("Звук не найден: " + sfx_key)
		return
	
	var stream = audio_data.get(sfx_key)
	if stream is AudioStream:
		free_player.stream = stream
		free_player.play()
	else:
		push_error("Ресурс не является AudioStream: " + sfx_key)


func _get_free_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null



func set_music_volume(volume_db: float) -> void:
	music_volume_db = volume_db
	music_player.volume_db = volume_db


func set_sfx_volume(volume_db: float) -> void:
	sfx_volume_db = volume_db
	for player in sfx_players:
		player.volume_db = volume_db


func set_volume(volume_db: float) -> void:
	set_music_volume(volume_db)
	set_sfx_volume(volume_db)
