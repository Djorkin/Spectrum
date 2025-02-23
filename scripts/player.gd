extends CharacterBody3D

class_name Player

# Параметры игрока
var mouse_sensitivity: float
var movement_speed: float
var fast_speed_multiplier: float
var gravity: float
var player_peer_id: int = -1
var skill_id: int

@export var player_params: PlayerResource
@export var state_machine: Player_FSM

@onready var label_3d: Label3D = $Label3D
@onready var target_ik: Node3D = $Target_IK
@onready var player_body: Node3D = $player
@onready var skeleton_ik_3d: SkeletonIK3D = $player/Armature/Skeleton3D/SkeletonIK3D
@onready var camera_3d: Camera3D = $player/Armature/Skeleton3D/BoneAttachment3D/Camera3D
@onready var spectr_effector: ColorRect = $player/Armature/Skeleton3D/BoneAttachment3D/Camera3D/Spectr_Effector



func _ready():
	init_params()
	skeleton_ik_3d.start()


func set_player(ID: int) -> void:
	player_peer_id = ID
	label_3d.text = str(player_peer_id)
	
	if !is_multiplayer_authority():
		return

	if is_multiplayer_authority():
		camera_3d.current = true
		state_machine.setup()
	else:
		camera_3d.current = false


func init_params():
	if player_params:
		label_3d.text = player_params.naming
		mouse_sensitivity = SettingsConfig.get_value("controls", "m_sense")
		movement_speed = player_params.movement_speed
		fast_speed_multiplier = player_params.fast_speed_multiplier
		gravity = player_params.gravity
		skill_id = player_params.skill_id



# Сохранение данных
func get_save_data() -> Dictionary:
	return {
		"position": position,
	}

# Загрузка данных
func set_save_data(data: Dictionary):
	position = data["position"]

# Регистрация в системе сохранения
func _enter_tree():
	SaveSystem.register_object(self)

# Удаление из системы сохранения
func _exit_tree():
	SaveSystem.unregister_object(self)
