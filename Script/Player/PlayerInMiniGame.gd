extends CharacterBody2D
class_name PlayerInMiniGame

@export var speed: float = 100

var position_to_move: Vector2 = Vector2.ZERO
const MIN_DISTANCE: float = 5.0

func _ready() -> void:
	
	Signals.move_player_to_point.connect(func (pos) -> void: position_to_move = pos)

func _process(delta: float) -> void:
	velocity = position.direction_to(position_to_move) * speed * delta
	
	if position.distance_squared_to(position_to_move) > MIN_DISTANCE:
		move_and_slide()