extends CharacterBody2D
class_name PlayerInMiniGame

@export var speed: float = 100
@export var position_to_move: Vector2 = Vector2(70,87)

const MIN_DISTANCE: float = 5.0

var can_move: bool = true

func _ready() -> void:
	Signals.move_player_to_point.connect(func (pos) -> void:
		if can_move:
			position_to_move = pos
			# Dezaktywuj wszystkie punkty gdy gracz zaczyna się poruszać
			Signals.disable_all_stop_points.emit()
	)
	Signals.set_player_pos.connect(func (pos) -> void: global_position = pos)
	
func _process(delta: float) -> void:
	velocity = position.direction_to(position_to_move) * speed * delta

	if position.distance_squared_to(position_to_move) > MIN_DISTANCE:
		can_move = false
		move_and_slide()
	else:
		position = position_to_move
		can_move = true
		Signals.player_in_stop_point.emit(position_to_move)
