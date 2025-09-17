extends Node2D
class_name StopPoint

@export var neighbor_point: Array[StopPoint] = []
@export var is_active: bool = false
@export var is_finish: bool = false

@onready var sprite: Sprite2D = $Area2D/Sprite2D

var patrol_on_point: bool = false
var player_on_point: bool = false

var mouse_on: bool = false

func _ready():
	Signals.disabe_stop_point.connect(
		func (): 
			player_on_point = false
			is_active = false
	)

func _process(_delta: float) -> void:
	if patrol_on_point and player_on_point:
		print("game over")
	
	if mouse_on and Input.is_action_just_pressed("MovePlayer") and is_active:
		
		Signals.move_player_to_point.emit(self.global_position)
		Signals.disabe_stop_point.emit()
		for nightbor in neighbor_point:
			nightbor.is_active = true
		player_on_point = true
	
	if is_finish and player_on_point :
		print("wygrana")

func _on_area_2d_mouse_entered() -> void:
	mouse_on = true
	if is_active:
		sprite.modulate = Color(0.29803923, 0.80784315, 0.40392157)

func _on_area_2d_mouse_exited() -> void:
	mouse_on = false
	sprite.modulate = Color(1,1,1,1)
