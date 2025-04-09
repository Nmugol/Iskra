extends CharacterBody2D

@export var speed: float = 100
@export var gravity: float = 980
@onready var nav: NavigationAgent2D = $NavigationAgent2D

var mouse_pos = Vector2()

func _ready() -> void:
	Signals.save_game.connect(SavePlayerData)

func _physics_process(delta: float) -> void:
	if not State.IsRun:
		return

	if Input.is_action_pressed("MovePlayer") and State.IsInArea:
		nav.target_position = get_global_mouse_position()

	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = direction * speed

	move_and_slide()

func SavePlayerData() -> void:
	Save.PlayerPosition = position
