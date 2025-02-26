extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 10
@export var stop_threshold: float = 5

var mouse_pos = Vector2()

func _ready() -> void:

	Signals.connect("save_game", SavePlayerData)
	SetUp()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("MovePlayer"):
		pass
	else:
		velocity = Vector2.ZERO  # Zatrzymanie postaci
	
	move_and_slide()

func SavePlayerData() -> void:
	Save.PlayerPosition = position
	Save.Equipment = []

func SetUp() -> void:
	position = Save.PlayerPosition
	mouse_pos = Save.PlayerPosition
