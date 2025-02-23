@tool
extends Node3D

@export var speed: float = 2.0  
@export var distance: float = 3.0  

var direction: int = 1 
var start_position: Vector3

func _ready():
	start_position = position 

func _process(delta):
	self.rotate_x(delta)
	self.rotate_y(delta)
	if Engine.is_editor_hint():
		self.rotate_x(delta)
		self.rotate_y(delta)
	
	position.x += direction * speed * delta

	if abs(position.x - start_position.x) > distance:
		direction *= -1

	if Engine.is_editor_hint():
		position.x += direction * speed * delta
