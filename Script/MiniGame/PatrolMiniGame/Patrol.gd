extends CharacterBody2D
class_name Patrol

@export var speed: float = 100
@export var position_to_move: Vector2 = Vector2(70,87)

const MIN_DISTANCE: float = 5.0
var is_moving: bool = true

var is_active: bool = true
var patrol_id: String = ""

func _ready() -> void:
    # Generuj unikalne ID dla każdego patrolu
    patrol_id = str(get_instance_id())
    
    Signals.move_patrol_to_point.connect(
        func (id, pos):
            if id == patrol_id:
                position_to_move = pos
                is_moving = true
    )


func _process(delta: float) -> void:
    if not is_active: return
    if not is_moving: return

    velocity = position.direction_to(position_to_move) * speed * delta

    if position.distance_squared_to(position_to_move) > MIN_DISTANCE:
        move_and_slide()
    else:
        position = position_to_move
        is_moving = false
        Signals.patrol_in_stop_point.emit(patrol_id, position_to_move)

# Dodatkowa metoda aktywacji jeśli potrzebna
func activate() -> void:
    is_active = true
    is_moving = true