extends Node2D
class_name Symbol

@export_category("Parameters")
@export var symbol_icons: CompressedTexture2D # Ikona symbolu
@export var offset_value: Vector2 = Vector2(0,0) # Początkowy offset symbolu
@export var rotation_speed: float = 4.0 # Prędkość obrotu
@export_range(-1, 1, 2) var rotation_direction: float = 1 # Kierunek obrotu (-1 lub 1)
@export var target_rotation_value: float = 0.0 # Docelowa wartość rotacji
@export var target_offset_value: Vector2 = Vector2(0,0) # Docelowy offset
@export var moving_distance_y: float = 10.0 # Prędkość przesuwania
@export var moving_distance_x: float = 10.0 # Prędkość przesuwania

@export_range(0,50,0.5) var max_distance_tolerance: float = 1 # Maksymalna tolerancja odległości
@export_range(0,180,1) var max_rotation_tolerance: float = 45.0 # Maksymalna tolerancja rotacji (w stopniach)

@export_range(0,1,0.01) var toleration_procent: float = 0.95 # Procent tolerancji

@export_category("Node")
@export var center_point: Marker2D # Punkt centralny
@export var border_area: Area2D # Punkt obrotu

@export_category("References")
@export var target: Sprite2D # Docelowy sprite
@export var symbol: Sprite2D # Sprite symbolu
@export var rotation_point: Marker2D # Punkt obrotu symbolu
@export var target_rotation_point: Marker2D # Docelowy punkt obrotu
@export var area_2d: Area2D 

var rotate_flag: bool = false # Czy obracać symbol
var rotate_to_left_flag: bool = false # Czy obracać w lewo

var move_on_x_axis: bool = false # Czy przesuwać po osi X
var move_on_y_axis: bool = false # Czy przesuwać po osi Y

var move_left_flag: bool = false # Czy przesuwać w lewo
var move_up_flag: bool = false # Czy przesuwać w górę

var in_target: bool = false #Czy jest w docelowym punkcie

var in_border_area: bool = false
var is_active: bool = false # Czy symbol jest aktywny

func _ready() -> void:

	global_position = center_point.global_position

	connect_signals()

	set_up()
	
	update_symbol_opacity()

func set_up() -> void:
	# Inicializacja tekstur i wartości początkowych
	target.texture = symbol_icons
	target.offset = target_offset_value
	target_rotation_point.rotation_degrees = target_rotation_value
	symbol.texture = symbol_icons
	symbol.offset = offset_value
	in_target = false
	rotate_flag = false
	move_on_x_axis = false
	move_on_y_axis = false
	self.show()

	area_2d.area_exited.connect(func(area: Area2D) -> void:
		if area == border_area:
			in_border_area = false
			self.hide()
			)
	
	area_2d.area_entered.connect(func(area: Area2D) -> void:
		if area == border_area:
			in_border_area = true
			self.show()
			)

func connect_signals() -> void:
	Signals.rotate_symbol.connect(func(left: bool) -> void:
		rotate_flag = true
		rotate_to_left_flag = left
		)
	
	Signals.symbol_move_on_x_axis.connect(func(left: bool) -> void:
		move_on_x_axis = true
		move_left_flag = left
		)

	Signals.symbol_move_on_y_axis.connect(func(up: bool) -> void:
		move_on_y_axis = true
		move_up_flag = up
		)
	
	Signals.stop_moving_and_rotate_symbol.connect(func() -> void:
		rotate_flag = false
		move_on_x_axis = false
		move_on_y_axis = false
		)

func _process(delta: float) -> void:
	if not is_active:
		return

	# Obsługa obrotu symbolu
	if rotate_flag:
		if rotate_to_left_flag:
			if rotation_speed == 0:
				return
			rotation_point.global_rotation -= deg_to_rad(rotation_speed * rotation_direction) * delta
		else:
			if rotation_speed == 0:
				return
			rotation_point.global_rotation += deg_to_rad(rotation_speed * rotation_direction) * delta

	# Obsługa przesuwania po osi X
	if move_on_x_axis:
		if move_left_flag:
			if moving_distance_x == 0:
				return
			symbol.offset.x += -moving_distance_x * delta
		else:
			if moving_distance_x == 0:
				return
			symbol.offset.x -= -moving_distance_x * delta

	# Obsługa przesuwania po osi Y
	if move_on_y_axis:
		if move_up_flag:
			if moving_distance_y == 0:
				return
			symbol.offset.y -= moving_distance_y * delta
		else:
			if moving_distance_y == 0:
				return
			symbol.offset.y += moving_distance_y * delta
	area_2d.global_position = symbol.global_position
	area_2d.position += symbol.offset
	update_symbol_opacity()
	symbol_in_target_space()

func update_symbol_opacity() -> void:

	if not in_border_area:
		symbol.modulate = Color(1, 1, 1, 0)
		return

	# Ustaw przezroczystość symbolu na podstawie dopasowania do celu
	symbol.modulate = Color(1, 1, 1, calculate_match_percentage())

func calculate_match_percentage() -> float:
	# Oblicz dopasowanie odległości (0.0 - 1.0)
	var offset_distance = symbol.offset.distance_to(target.offset)
	var distance_match = 1.0 - clamp(offset_distance / max_distance_tolerance, 0.0, 1.0)
	
	# Oblicz dopasowanie rotacji (0.0 - 1.0)
	var rotation_diff = abs(rotation_point.rotation_degrees - target_rotation_value)
	var rotation_match = 1.0 - clamp(rotation_diff / max_rotation_tolerance, 0.0, 1.0)
	
	# Połącz oba współczynniki (średnia ważona)
	var overall_match = (distance_match * 0.7 + rotation_match * 0.3)
	
	return overall_match

# Sprawdź, czy symbol jest wystarczająco dopasowany do celu (>= 95%)
func symbol_in_target_space() -> void:
	if calculate_match_percentage() >= toleration_procent and not in_target:
		in_target = true
		return

	if in_target and calculate_match_percentage() < toleration_procent: 
		in_target = false
		return
