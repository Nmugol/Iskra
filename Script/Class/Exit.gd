extends Area2D
class_name Exit

@export var location_path: String

@export var min_distance: float = 500

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
		dist = floor(global_transform.origin.distance_to(player.global_transform.origin))

		mouse_hover = true
		)

	mouse_exited.connect(func():
		mouse_hover = false
		)

func _process(_delta: float) -> void:
	if mouse_hover:
		if Input.is_action_just_pressed("MovePlayer") and dist <= min_distance:

			in_scene = false
			print(dist)

			Save.CurrentScenePath = location_path
			Save.PlayerPosition = target_player_position
			get_tree().change_scene_to_file(MainScene)

		if Input.is_action_just_pressed("MovePlayer") and dist > min_distance and in_scene:


			player.nav.target_position = stopping_point
			print(dist)
			dist = floor(position.distance_to(player.position))
