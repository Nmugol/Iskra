# StopPoint.gd
extends Node2D
class_name StopPoint

@export var neighbor_point: Array[StopPoint] = []
@export var is_active: bool = false
@export var is_finish: bool = false
@export var starting_patrols: Array[NodePath] = []  # Ścieżki do patroli które startują z tego punktu

@onready var sprite: Sprite2D = $Area2D/Sprite2D

# Słowniki do śledzenia wielu patroli
var patrols_on_point: Dictionary = {}  # {patrol_id: bool}
var patrols_going_to_point: Dictionary = {}  # {patrol_id: bool}

var player_on_point: bool = false
var mouse_on: bool = false
var finish: bool = false

func _ready():
	# Inicjalizuj patrole startujące z tego punktu
	initialize_starting_patrols()

	Signals.disable_stop_point.connect(
		func ():
			player_on_point = false
			is_active = false
	)
	
	# Dodaj nowy sygnał do dezaktywacji wszystkich punktów
	Signals.disable_all_stop_points.connect(
		func():
			player_on_point = false
			is_active = false
	)

	Signals.player_in_stop_point.connect(
		func(pos):
			if pos == self.global_position:
				player_on_point = true
				# Aktywuj sąsiednie punkty dopiero po dotarciu gracza
				for neighbor in neighbor_point:
					neighbor.is_active = true
			else:
				player_on_point = false
	)
	
	Signals.patrol_in_stop_point.connect(patrol_next_move)
	Signals.patrol_left_point.connect(patrol_left_point)

func initialize_starting_patrols() -> void:
	for patrol_path in starting_patrols:
		var patrol: Patrol = get_node(patrol_path) as Patrol
		if patrol:
			patrol.activate()
			patrols_on_point[patrol.patrol_id] = true
			# Ustaw pozycję patrolu na tym punkcie
			patrol.global_position = self.global_position
			# Rozpocznij ruch po krótkim opóźnieniu
			await get_tree().create_timer(0.5).timeout
			patrol_next_move(patrol.patrol_id, self.global_position)

func _process(_delta: float) -> void:
	# Sprawdź kolizję z dowolnym patrolem
	if player_on_point and not patrols_on_point.is_empty():
		Signals.reset_level.emit()

	# Usunięto aktywację sąsiadów przy kliknięciu - teraz dzieje się to po dotarciu gracza
	if mouse_on and Input.is_action_just_pressed("MovePlayer") and is_active:
		Signals.move_player_to_point.emit(self.global_position)

	if is_finish and player_on_point:
		if finish: return
		finish = true
		Signals.next_level.emit()

	# Aktualizuj kolor sprite'a jeśli którykolwiek patrol zmierza do tego punktu
	if not patrols_going_to_point.is_empty():
		sprite.modulate = Color(1, 0, 0)

func _on_area_2d_mouse_entered() -> void:
	mouse_on = true
	if is_active:
		sprite.modulate = Color(0.29803923, 0.80784315, 0.40392157)

func _on_area_2d_mouse_exited() -> void:
	mouse_on = false
	sprite.modulate = Color(1, 1, 1, 1)

func patrol_next_move(patrol_id: String, pos: Vector2) -> void:
	if not pos == self.global_position: return

	patrols_on_point[patrol_id] = true
	patrols_going_to_point.erase(patrol_id)

	if patrols_going_to_point.is_empty():
		sprite.modulate = Color(1, 1, 1, 1)

	await get_tree().create_timer(0.5).timeout

	if neighbor_point.size() > 0 and patrols_on_point.has(patrol_id):
		var random_index: int = randi() % neighbor_point.size()
		var next_point: StopPoint = neighbor_point[random_index]

		next_point.patrols_going_to_point[patrol_id] = true
		Signals.move_patrol_to_point.emit(patrol_id, next_point.global_position)
		Signals.patrol_left_point.emit(patrol_id, self.global_position)
		patrols_on_point.erase(patrol_id)

func patrol_left_point(patrol_id: String, pos: Vector2) -> void:
	if pos == self.global_position:
		patrols_on_point.erase(patrol_id)
		patrols_going_to_point.erase(patrol_id)
		if patrols_going_to_point.is_empty():
			sprite.modulate = Color(1, 1, 1, 1)
