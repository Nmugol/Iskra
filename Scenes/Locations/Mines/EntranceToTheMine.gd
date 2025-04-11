extends Area2D

@export var HightLight: PointLight2D
@export var Player: CharacterBody2D
@export var MinDistance: float = 100

var dist

func _ready() -> void:
	HightLight.hide()
	

func _process(_delta: float) -> void:
	if HightLight.visible:

		if Input.is_action_just_pressed("MovePlayer") and dist <= MinDistance:
			print("Można wejść") 
		if Input.is_action_just_pressed("MovePlayer") and dist > MinDistance:
			Player.nav.target_position = Vector2(1030, -150)

func _on_mouse_entered() -> void:
	HightLight.show()
	dist = sqrt(pow(Player.position.x - position.x,2)+pow(Player.position.y - position.y,2))


func _on_mouse_exited() -> void:
	HightLight.hide()
