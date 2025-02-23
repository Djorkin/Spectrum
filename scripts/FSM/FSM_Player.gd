extends FSM
class_name Player_FSM

@export var player : Player

var mouse_sensitivity: float
var movement_speed: float
var fast_speed_multiplier: float
var gravity: float 
var direction : Vector3
var rotation_x: float = 0.0
var rotation_y: float = 0.0
var target_ik: Node3D
var skeleton_ik_3d: SkeletonIK3D
var player_body: Node3D 
var is_falling = false
var active_FSM : bool = false 
var spectr_effector: ColorRect
var skill_id : int



func _ready() -> void:
	SignalGlobal.m_sense_change.connect(mouse_sense)
	super._ready()

func mouse_sense():
	mouse_sensitivity = SettingsConfig.get_value("controls", "m_sense")

func setup() -> void:
	movement_speed = player.movement_speed
	fast_speed_multiplier = player.fast_speed_multiplier
	mouse_sensitivity = player.mouse_sensitivity
	gravity = player.gravity
	target_ik = player.target_ik
	skeleton_ik_3d = player.skeleton_ik_3d
	player_body = player.player_body
	skeleton_ik_3d.influence = 0.9
	#spectr_effector = player.spectr_effector
	#skill_id = player.skill_id
	#if spectr_effector:
		#var new_material = spectr_effector.material.duplicate()
		#spectr_effector.material = new_material
		#
		#if new_material is ShaderMaterial:
			#new_material.set_shader_parameter("color_mode", skill_id)
			#Logger.log_(str(new_material.get_instance_id()), self)

	emit_signal("transit", "Idle")
	check_data()



func _process(delta: float) -> void:
	update(delta)
	_get_direction()
	floor_transit()
	player.velocity.y -= gravity * delta
	player.move_and_slide()
	
	#if Input.is_action_just_pressed("Spectr"):
		#if spectr_effector:
			#spectr_effector.visible = !spectr_effector.visible


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if active_FSM:
			super.handle_input(event)
			handle_input(event)


func floor_transit():
	if is_multiplayer_authority():
		if active_FSM:
			if player.is_on_floor():
				is_falling = false
				if Input.is_action_just_pressed("Jump"):
					emit_signal("transit", "Jump")
			else:
				if not is_falling:
					is_falling = true
					if not state_map.get("Jump") in state_stack:
						emit_signal("transit", "Falling")

func _get_direction():
	if is_multiplayer_authority():
		if active_FSM:
			direction = Vector3.ZERO
			if Input.is_action_pressed("Forward"):
				direction += player_body.transform.basis.z
			if Input.is_action_pressed("Back"):
				direction -= player_body.transform.basis.z
			if Input.is_action_pressed("Right"):
				direction -= player_body.transform.basis.x
			if Input.is_action_pressed("Left"):
				direction += player_body.transform.basis.x
			direction = direction.normalized()
			return direction

func rotate_head(input: InputEvent):
	if is_multiplayer_authority():
		if active_FSM:
			if input is InputEventMouseMotion and Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
				rotation_x += deg_to_rad(input.relative.y) * mouse_sensitivity
				rotation_y -= deg_to_rad(input.relative.x) * mouse_sensitivity
				rotation_x = clamp(rotation_x, -PI/3, PI/3)
				rotation_y = clamp(rotation_y, player_body.rotation.y + -PI/2, player_body.rotation.y + PI/2)
				target_ik.rotation.x = rotation_x
				target_ik.rotation.y = wrapf(rotation_y, -PI, PI)

func rotate_body(_delta):
	if is_multiplayer_authority():
		if active_FSM:
			if direction:
				player_body.rotation.y = lerp_angle(player_body.rotation.y, target_ik.rotation.y, PI * _delta)

func check_data():
	var required_variables = [player, mouse_sensitivity, movement_speed, fast_speed_multiplier, gravity, direction, target_ik, skeleton_ik_3d, player_body]
	active_FSM = not required_variables.has(null)
	if not required_variables.has(null):
		Logger.log_("Инициализация FSM успешна")
	else:
		active_FSM = false
		Logger.log_("Инициализация FSM провал")
