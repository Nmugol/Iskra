extends Node2D
class_name CableTile

# ZMIENNE TYPÓW ENUM (niezmienione)
enum CableType {
	STRAIGHT,     # Prosty
	CORNER_L,     # Zakręt w lewo
	CORNER_R,     # Zakręt w prawo
	CROSS,        # Skrzyżowanie
	T_JUNCTION,   # Skrzyżowanie w kształcie litery T
	DUAL_CORNER   # Jednoczesny skręt L/P (z dołu w lewo, z góry w prawo)
}

# STAŁE KIERUNKÓW (niezmienione)
const UP = Vector2i(0, -1)
const DOWN = Vector2i(0, 1)
const LEFT = Vector2i(-1, 0)
const RIGHT = Vector2i(1, 0)

# MAPA POŁĄCZEŃ (niezmieniona)
const CONNECTION_MAP = {
	CableType.STRAIGHT: [[UP, DOWN], [LEFT, RIGHT], [DOWN, UP], [RIGHT, LEFT]],
	CableType.CORNER_L: [[DOWN, LEFT], [LEFT, UP], [UP, RIGHT], [RIGHT, DOWN]],
	CableType.CORNER_R: [[DOWN, RIGHT], [RIGHT, UP], [UP, LEFT], [LEFT, DOWN]],
	CableType.CROSS: [[UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT]],
	CableType.T_JUNCTION: [[DOWN, LEFT, RIGHT], [UP, DOWN, LEFT], [UP, LEFT, RIGHT], [UP, DOWN, RIGHT]],
	CableType.DUAL_CORNER: [[DOWN, LEFT, UP, RIGHT], [LEFT, UP, RIGHT, DOWN], [UP, RIGHT, DOWN, LEFT], [RIGHT, DOWN, LEFT, UP]],
}

# WŁAŚCIWOŚCI
@export_category("Type")
@export var cable_type: CableType = CableType.STRAIGHT:
	set(value):
		cable_type = value
		if sprite:
			# POPRAWKA: Jawne rzutowanie na int, aby uniknąć ostrzeżenia INT_AS_ENUM_WITHOUT_CAST
			sprite.play(CableType.keys()[int(cable_type)])
	get():
		return cable_type

@export_category("Sprite")
@export var sprite: AnimatedSprite2D
@export_range(0,3,1) var rotation_step: int = 0

@export_category("Position")
@export var grid_position: Vector2i = Vector2i.ZERO

var neighbors_powered_from: Array[Vector2i] = []
var is_powered: bool = false
var game_is_start: bool = false # Stan blokujący interakcję, ustawiany przez GameManager

# USUNIĘTO: Funkcja _process i zmienna mouse_on (nadmiarowa logika kliknięcia)
# func _process(_delta: float) -> void: pass

func rotation_tile()->void:
	rotation_step = (rotation_step + 1) % 4
	sprite.rotation_degrees = rotation_step * 90

	# Emitowanie globalnego sygnału z poprawnym argumentem (grid_position)
	Signals.tile_rotated.emit(grid_position)

# FUNKCJA UŻYWANA PRZEZ BFS W GAME MANAGERZE
func get_connections():
	if rotation_step < 0 or rotation_step >= 4: return[]
	var type_map = CONNECTION_MAP.get(cable_type)
	if type_map == null: return []
	return type_map[rotation_step]

# FUNKCJA AKTUALIZUJĄCA STAN ZASILANIA
func set_power_state(powered: bool, powered_from: Array[Vector2i]) -> void:
	is_powered = powered
	neighbors_powered_from = powered_from

	# Aktualizacja wizualna
	if is_powered:
		sprite.modulate = Color.YELLOW
	else:
		sprite.modulate = Color.WHITE

# OBSŁUGA KLIKNIĘCIA (połączona ze sygnałem input_event z Area2D)
func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if game_is_start: return # Zablokowanie interakcji
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rotation_tile()
