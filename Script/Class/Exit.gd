extends Area2D
class_name Exit

@export var LocationPath: String
@export_range(10,200,1) var MinDistance: float = 100
@export var StoppingPoint: Vector2
@export var Player: CharacterBody2D

var dist
var mouse_hover: bool = false

func  _ready() -> void:
	mouse_entered.connect(func():
		dist = floor(position.distance_to(Player.position))
		mouse_hover = true
		)

	mouse_exited.connect(func():
		mouse_hover = false
		)

func _process(_delta: float) -> void:
	if mouse_hover:
		if Input.is_action_just_pressed("MovePlayer") and dist <= MinDistance:
			Save.CurrentScenePath = LocationPath
			Signals.enable_loadin_screen.emit()
			Signals.change_scene.emit()
		if Input.is_action_just_pressed("MovePlayer") and dist > MinDistance:
			Player.nav.target_position = StoppingPoint
			dist = floor(position.distance_to(Player.position))
