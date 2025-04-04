extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 7
@export var gravity: float = 980
@onready var nav: NavigationAgent2D = $NavigationAgent2D

var mouse_pos = Vector2()

func _ready() -> void:
	Signals.save_game.connect(SavePlayerData)
	

func _physics_process(delta: float) -> void:
	if not State.IsRun: return
	# Dodaj grawitację
	velocity.y += gravity * delta
	
	#TODO Dodanie area2d sprawdzjąceko czy kursor jerest w danym skresie 
	if Input.is_action_pressed("MovePlayer") and State.IsInArea:
		nav.target_position = get_global_mouse_position()
		
	var direction = (nav.get_next_path_position() - global_position).normalized()
	direction.y = 0  	
	velocity.x = direction.x * speed
	
	move_and_slide()

func SavePlayerData() -> void:
	Save.PlayerPosition = position
