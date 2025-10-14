class_name Player
extends CharacterBody2D

@export var speed: float = 100
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var spot_marc:AnimatedSprite2D = $SpotMark

const DISTANT_TO_CLICK: float = 10
var in_spot: bool = false

func _ready() -> void:
	Signals.save_game.connect(func () -> void: Save.player_position = position)
	sprite.scale = Vector2(0.5,0.5)
	sprite.play("idle")
	
	# Zabezpieczenie przed pustą pozycją
	if Save.player_position != Vector2.ZERO:
		position = Save.player_position
		# Resetuj animację i kierunek po wczytaniu
		sprite.play("idle")
		sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	if not is_inside_tree() or is_queued_for_deletion():
		return  # Zabezpieczenie jeśli węzeł jest usuwany		
		
	if not State.is_running:
		Signals.reset_cursor.emit()
		return

	if Input.is_action_pressed("MovePlayer") and State.is_in_area and distance_to_click() and not in_spot:
		navigation.target_position = get_global_mouse_position()
		in_spot = true
		spot_marc.global_position = get_global_mouse_position()
		spot_marc.show()
		spot_marc.play("default")



	if navigation.is_navigation_finished():
		velocity = Vector2.ZERO
		sprite.scale = Vector2(0.5,0.5)
		sprite.play("idle")
		spot_marc.hide()
		in_spot = false
		Signals.update_distance.emit()
	else:
		var next_pos = navigation.get_next_path_position()
		# Zabezpieczenie przed błędami nawigacji
		if is_instance_valid(navigation) and next_pos != Vector2.INF:
			var direction = (next_pos - global_position).normalized()
			velocity = direction * speed
			sprite.scale = Vector2(0.667,0.667)
			spot_marc.global_position = navigation.target_position
			# Poprawiona logika animacji
			update_animations(direction)

	# Dodajemy warunek sprawdzający czy możemy wykonać move_and_slide()
	if is_inside_tree() and get_world_2d() != null:
		move_and_slide()

# Wydzielona logika animacji
func update_animations(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		return
	
	var abs_direction = direction.abs()
	if abs_direction.x > abs_direction.y:
		if direction.x > 0:
			sprite.play("walk_right")
		else:
			sprite.play("walk_left")
	else:
		if direction.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")

func distance_to_click() -> bool:
	return global_position.distance_to(get_global_mouse_position()) >= DISTANT_TO_CLICK
