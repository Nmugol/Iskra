extends Area2D

class_name Exit

@export var location_path: String

@export_category("Area")
@export var area_shape: CollisionShape2D
@export var min_distance: float = 500

@export_category("Player")
@export var player: Player
@export var stopping_point: Vector2
@export var target_player_position: Vector2 = Vector2(0, 0)

var start_point: Vector2 = Vector2(0, 0)
var dist: int
var mouse_hover: bool = false
const MAIN_SCENE = "res://Scenes/World.tscn"

var in_scene: bool = true


func _ready() -> void:
	Signals.update_distance.connect(calculate_distance)

	calculate_distance()

	in_scene = true
	mouse_entered.connect(
		func():
			calculate_distance()
			mouse_hover = true
	)

	mouse_exited.connect(
		func():
			mouse_hover = false
	)


func calculate_distance() -> void:
	dist = floor(area_shape.global_position.distance_to(player.global_position))


func _process(_delta: float) -> void:
	if mouse_hover:
		if Input.is_action_just_pressed("MovePlayer") and dist <= min_distance:
			in_scene = false

			Save.current_scene_path = location_path
			Save.player_position = target_player_position
			Signals.enable_loading_screen.emit()
			get_tree().change_scene_to_file(MAIN_SCENE)

		if Input.is_action_just_pressed("MovePlayer") and dist > min_distance and in_scene:
			player.navigation.target_position = stopping_point
