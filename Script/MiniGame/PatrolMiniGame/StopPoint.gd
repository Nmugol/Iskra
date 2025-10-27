# StopPoint.gd
extends Node2D

class_name StopPoint

@export_category("Movement")
@export var neighbor_point: Array[StopPoint] = []
@export var is_active: bool = false
@export var is_finish: bool = false
@export var starting_patrols: Array[NodePath] = [] # Ścieżki do patroli które startują z tego punktu

@export_category("Audio")
@export var button_sfx: AudioStream

@onready var sprite: AnimatedSprite2D = $Area2D/Sprite2D

# Słowniki do śledzenia wielu patroli
var patrols_on_point: Dictionary = { } # {patrol_id: bool}
var patrols_going_to_point: Dictionary = { } # {patrol_id: bool}

var player_on_point: bool = false
var mouse_on: bool = false
var finish: bool = false
var is_resetting: bool = false # Kontrola resetu


func _ready():
	# Inicjalizuj patrole startujące z tego punktu
	initialize_starting_patrols()

	Signals.disable_stop_point.connect(
		func():
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
			if pos == self.position:
				player_on_point = true
				# Aktywuj sąsiednie punkty dopiero po dotarciu gracza
				for neighbor in neighbor_point:
					neighbor.is_active = true
			else:
				player_on_point = false
	)

	Signals.patrol_in_stop_point.connect(patrol_next_move)
	Signals.patrol_left_point.connect(patrol_left_point)

	# Obsługa sygnału reset_level
	Signals.reset_level.connect(_on_reset_level)


func initialize_starting_patrols() -> void:
	for patrol_path in starting_patrols:
		var patrol: Patrol = get_node(patrol_path) as Patrol
		if patrol:
			patrol.is_active = true
			patrols_on_point[patrol.patrol_id] = true
			# Ustaw pozycję patrolu na tym punkcie
			patrol.position = self.position
			patrol.position_to_move = self.position
			patrol.is_moving = false
			# Rozpocznij ruch po krótkim opóźnieniu
			await get_tree().create_timer(0.5).timeout
			if not is_resetting: # Tylko jeśli nie trwa reset
				patrol_next_move(patrol.patrol_id, self.position)


func _process(_delta: float) -> void:
	if not is_active:
		sprite.play("disable")

	else:
		sprite.play("default")

	if is_finish:
		sprite.play("home")

	if patrols_going_to_point:
		sprite.play("patrol")

	if Input.is_action_just_pressed("MovePlayer") and State.can_play_sfx:
		Signals.play_sound.emit(State.AudioType.Effect, button_sfx, 1, -5)

	if player_on_point and not patrols_on_point.is_empty():
		Signals.reset_level.emit()

	if mouse_on and Input.is_action_just_pressed("MovePlayer") and is_active and not is_resetting:
		Signals.move_player_to_point.emit(self.position)

	if is_finish and player_on_point:
		if finish:
			return
		finish = true
		Signals.next_level.emit()


func _on_area_2d_mouse_entered() -> void:
	mouse_on = true


func _on_area_2d_mouse_exited() -> void:
	mouse_on = false


func patrol_next_move(patrol_id: String, pos: Vector2) -> void:
	if pos != self.position:
		return

	if is_resetting:
		return

	patrols_on_point[patrol_id] = true
	patrols_going_to_point.erase(patrol_id)

	await get_tree().create_timer(0.5).timeout

	if neighbor_point.size() > 0 and patrols_on_point.has(patrol_id) and not is_resetting:
		var random_index: int = randi() % neighbor_point.size()
		var next_point: StopPoint = neighbor_point[random_index]

		# Sprawdź czy następny punkt nie jest w trakcie resetu
		if not next_point.is_resetting:
			next_point.patrols_going_to_point[patrol_id] = true
			Signals.move_patrol_to_point.emit(patrol_id, next_point.position)
			Signals.patrol_left_point.emit(patrol_id, self.global_position)
			patrols_on_point.erase(patrol_id)


func patrol_left_point(patrol_id: String, pos: Vector2) -> void:
	if pos == self.position:
		patrols_on_point.erase(patrol_id)
		patrols_going_to_point.erase(patrol_id)


func _on_reset_level() -> void:
	is_resetting = true
	is_active = false
	player_on_point = false
	mouse_on = false
	finish = false

	# Zresetuj słowniki patroli
	patrols_on_point.clear()
	patrols_going_to_point.clear()

	# Po krótkim czasie odblokuj punkty
	await get_tree().create_timer(0.1).timeout
	is_resetting = false

	# Ponowna inicjalizacja tylko punktów startowych patroli
	if not starting_patrols.is_empty():
		await get_tree().create_timer(0.2).timeout
		initialize_starting_patrols()
