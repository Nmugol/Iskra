extends Area2D

@export var HightLight: PointLight2D
@export var Player: CharacterBody2D
@export var MinDistance: float = 100
@export var LocationPath: String = "res://Scenes/Locations/Mines/Cave1.tscn"
var MainScene = "res://Scenes/World.tscn"
var dist
var in_scene: bool = true

func _ready() -> void:
	in_scene = true
	HightLight.hide()

func _process(_delta: float) -> void:
	if HightLight.visible:

		if Input.is_action_just_pressed("MovePlayer") and dist <= MinDistance:
			
			Save.CurrentScenePath = LocationPath
			Save.PlayerPosition = Vector2(314,131)
			get_tree().change_scene_to_file(MainScene)
			in_scene = false
			
		if Input.is_action_just_pressed("MovePlayer") and dist > MinDistance and in_scene:
			Player.nav.target_position = Vector2(1030, -150)

func _on_mouse_entered() -> void:
	HightLight.show()
	dist = sqrt(pow(Player.position.x - position.x,2)+pow(Player.position.y - position.y,2))


func _on_mouse_exited() -> void:
	HightLight.hide()
