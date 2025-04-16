extends Area2D
class_name Exit

@export var location_path: String
@export_range(10,200,1) var min_distance: float = 100

@export_category("Player")
@export var player: CharacterBody2D
@export var stopping_point: Vector2
@export var target_player_position : Vector2 = Vector2(0,0)

var dist
var mouse_hover: bool = false
const  MainScene = "res://Scenes/World.tscn"

var in_scene: bool = true

func  _ready() -> void:
	in_scene = true
	mouse_entered.connect(func():
		dist = floor(position.distance_to(player.position))
		mouse_hover = true
		)

	mouse_exited.connect(func():
		mouse_hover = false
		)

func _process(_delta: float) -> void:
	if mouse_hover:
		if Input.is_action_just_pressed("MovePlayer") and dist <= min_distance:
			in_scene = false
			Save.CurrentScenePath = location_path
			Save.PlayerPosition = target_player_position
			Signals.enable_loadin_screen.emit()
			Signals.change_scene.emit()
			
		if Input.is_action_just_pressed("MovePlayer") and dist > min_distance and in_scene:
			player.nav.target_position = stopping_point
			dist = floor(position.distance_to(player.position))
