extends Area2D

@export var hightLight: PointLight2D
@export var player: Player
@export var min_distance: float = 100
@export var location_path: String = "res://Scenes/Locations/Mines/Cave1.tscn"

var dist
var in_scene: bool = true


func _ready() -> void:
	in_scene = true
	hightLight.hide()


func _process(_delta: float) -> void:
	if hightLight.visible:
		if Input.is_action_just_pressed("MovePlayer") and dist <= min_distance:
			Save.current_scene_path = location_path
			Save.player_position = Vector2(314, 131)
			get_tree().change_scene_to_file(State.MAIN_SCENE)
			in_scene = false

		if Input.is_action_just_pressed("MovePlayer") and dist > min_distance and in_scene:
			player.navigation.target_position = Vector2(1030, -150)


func _on_mouse_entered() -> void:
	hightLight.show()
	dist = sqrt(pow(player.position.x - position.x, 2) + pow(player.position.y - position.y, 2))


func _on_mouse_exited() -> void:
	hightLight.hide()
