extends CharacterBody2D

@export var speed: float = 100
@export var gravity: float = 980
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	Signals.save_game.connect(SavePlayerData)
	sprite.play("idle")
	position = Save.PlayerPosition

func _physics_process(_delta: float) -> void:
	if not State.IsRun:
		return

	if Input.is_action_pressed("MovePlayer") and State.IsInArea:
		nav.target_position = get_global_mouse_position()

	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
		sprite.play("idle")
		Signals.update_distanace.emit()
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = direction * speed
		
		if velocity.x > 0:
			sprite.flip_h = false
			
		else:
			sprite.flip_h = true
			
		sprite.play("walk")

	move_and_slide()

func SavePlayerData() -> void:
	Save.PlayerPosition = position
