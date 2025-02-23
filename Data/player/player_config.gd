extends Resource
class_name PlayerResource
@export_category("Settings")
@export var naming: String = "Player"
@export_range(0,1,0.01) var mouse_sensitivity: float = 0.1
@export_range(1,20,1) var movement_speed: float = 10.0
@export_range(2, 5, 0.1) var fast_speed_multiplier: float = 2.0
@export var gravity: float = 9.8
@export_range(0, 2) var skill_id: int = 0
