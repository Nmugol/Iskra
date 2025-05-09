extends CharacterBody2D

@export var speed: float = 100
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $Sprite2D

const distansToClick: float = 30

func _ready() -> void:
	Signals.save_game.connect(SavePlayerData)
	sprite.scale = Vector2(0.5,0.5)
	sprite.play("idle")
	position = Save.PlayerPosition

func _physics_process(_delta: float) -> void:
	if not State.IsRun:
		return

	if Input.is_action_pressed("MovePlayer") and State.IsInArea and DistaneToClick():
		nav.target_position = get_global_mouse_position()

	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
		sprite.scale = Vector2(0.5,0.5)
		for i in 2:
			await get_tree().process_frame
		sprite.play("idle")
		Signals.update_distanace.emit()
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = direction * speed
		sprite.scale = Vector2(0.667,0.667)
		

		if velocity.x == 0 and  velocity.y > 0:
			sprite.play("walk_down")
		
		if velocity.x == 0 and  velocity.y < 0:
			sprite.play("walk_up")
		
		else :
			if velocity.x > 0:
				sprite.play("walk_right")
		
			if velocity.x < 0:
				sprite.play("walk_left")

	move_and_slide()

func DistaneToClick() -> float:
	var d = global_position.distance_to(get_global_mouse_position())
	
	if d >= distansToClick: return true
	return false

func SavePlayerData() -> void:
	Save.PlayerPosition = position
