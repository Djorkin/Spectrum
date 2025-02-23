extends CharacterBody3D

@export var mouse_sensitivity: float = 0.1
@export var movement_speed: float = 10.0
@export var fast_speed_multiplier: float = 3.0

var rotation_x: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Поворачиваем камеру по горизонтали
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		# Поворачиваем камеру по вертикали с ограничением
		rotation_x -= -event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)
		rotation_degrees.x = rotation_x

func _process(_delta: float) -> void:
	var direction = Vector3.ZERO

	# Получаем направление движения
	if Input.is_action_pressed("w"):
		direction += transform.basis.z
	if Input.is_action_pressed("s"):
		direction -= transform.basis.z
	if Input.is_action_pressed("d"):
		direction -= transform.basis.x
	if Input.is_action_pressed("a"):
		direction += transform.basis.x
	if Input.is_action_pressed("space"):
		direction += transform.basis.y
	if Input.is_action_pressed("c"):
		direction -= transform.basis.y

	direction = direction.normalized()


	var speed = movement_speed
	if Input.is_action_pressed("shift"):
		speed *= fast_speed_multiplier


	if direction != Vector3.ZERO:
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO


	move_and_slide()
