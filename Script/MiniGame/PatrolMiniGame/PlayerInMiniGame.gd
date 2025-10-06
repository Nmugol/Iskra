extends CharacterBody2D
class_name PlayerInMiniGame

const MIN_DISTANCE: float = 5.0

var _can_move: bool = true
var _is_resetting: bool = false # Kontrola resetu
@export var _position_to_move: Vector2 = Vector2(70, 87)
@export var speed: float = 5000

func _ready() -> void:
	Signals.move_player_to_point.connect(_on_move_player_to_point)
	Signals.set_player_pos.connect(_on_set_player_pos)
	Signals.reset_level.connect(_on_reset_level)
	
func _on_move_player_to_point(pos: Vector2) -> void:
	if _can_move and not _is_resetting:
		_position_to_move = pos
		# dezaktywuj wszystkie punkty gdy gracz zaczyna się poruszać
		Signals.disable_all_stop_points.emit()
		

func _on_set_player_pos(pos: Vector2) -> void:
	global_position = pos	
	_position_to_move = pos # Zresetuj cel ruchu
	
func _process(delta: float) -> void:
	if _is_resetting: return
		
	velocity = position.direction_to(_position_to_move) * speed * delta


	if position.distance_squared_to(_position_to_move) > MIN_DISTANCE:
		_can_move = false
		move_and_slide()
	
	else:
		position = _position_to_move
		_can_move = true
		Signals.player_in_stop_point.emit(_position_to_move)

func _on_reset_level() -> void:
	_is_resetting = true
	_can_move = false
	_position_to_move = global_position # Zatrzymaj ruch

    # Odblokuj po krótkim czasie
	await get_tree().create_timer(0.2).timeout
	_is_resetting = false
	_can_move = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Patrol"):
		print("player in patrol")
		Signals.reset_level.emit()
