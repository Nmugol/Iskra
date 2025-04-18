extends Area2D
class_name Exit

@export var location_path: String

@export_category("Arrea")
@export var area_shape: CollisionShape2D
@export var min_distance: float = 500

@export_category("Player")
@export var player: CharacterBody2D
@export var stopping_point: Vector2
@export var target_player_position : Vector2 = Vector2(0,0)

var start_point: Vector2 = Vector2(0,0)
var dist: int
var mouse_hover: bool = false
const  MainScene = "res://Scenes/World.tscn"

var in_scene: bool = true

func  _ready() -> void:
	in_scene = true
	mouse_entered.connect(func():
		
		
		
		print("Pozycja obiektu",position)
		print("pozycja gracza", player.global_position)
		
		CalculateDistance()
		
		print("Dystans", dist)
		mouse_hover = true
		)

	mouse_exited.connect(func():
		mouse_hover = false
		)

func CalculateDistance() -> void:
	
	
	
	#var d1 = sqrt(pow(area_shape.global_position.x - start_point.x,2)+pow(area_shape.global_position.y-start_point.y,2))
	#var d2 = sqrt(pow(player.global_position.x - start_point.x,2)+pow(player.global_position.y-start_point.y,2))
	dist = floor(global_position.distance_to(player.global_position))

func _process(_delta: float) -> void:
	if mouse_hover:
		if Input.is_action_just_pressed("MovePlayer") and dist <= min_distance:

			in_scene = false

			Save.CurrentScenePath = location_path
			Save.PlayerPosition = target_player_position
			get_tree().change_scene_to_file(MainScene)

		if Input.is_action_just_pressed("MovePlayer") and dist > min_distance and in_scene:


			player.nav.target_position = stopping_point

			CalculateDistance()
			print(dist)
