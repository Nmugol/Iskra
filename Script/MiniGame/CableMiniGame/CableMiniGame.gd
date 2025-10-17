extends Node2D

const LEVEL_DATA = [

	{
		"size": Vector2i(5, 5),
		"source": [Vector2i(0, 2)], 
		"target": [Vector2i(4, 2)],
		"tiles": [
			[0, 2, 0, 0], 
			[1, 2, 0, 0], 
			[2, 2, 0, 0], 
			[3, 2, 0, 0], 
			[4, 2, 0, 0],

			[0, 0, 1, 3], 
			[1, 0, 4, 0], 
			[2, 0, 2, 1], 
			[3, 0, 5, 2], 
			[4, 0, 1, 0],

			[0, 1, 0, 0], 
			[1, 1, 3, 0], 
			[2, 1, 0, 1], 
			[3, 1, 4, 3], 
			[4, 1, 2, 2], 

			[0, 3, 2, 1], 
			[1, 3, 4, 1], 
			[2, 3, 5, 0], 
			[3, 3, 1, 2], 
			[4, 3, 0, 0], 

			[0, 4, 0, 1], 
			[1, 4, 2, 0], 
			[2, 4, 3, 0], 
			[3, 4, 1, 3], 
			[4, 4, 5, 1], 
		]
	},
]

@export_category("Grid Settings")
@export var grid_size: Vector2i = Vector2i(5,5)
@export var tile_scene: PackedScene # Wymaga CableTile.tscn
@export var tile_size: float = 32.0
@export var tile_container: Node2D

@export_category("Energi input and output")
@export var source_positions: = [Vector2i(0, 2)] 
@export var target_positions: = [Vector2i(4, 2)] 

var grid: Array[Array] = [] # Tablica przechowująca instancje CableTile
var is_game_active: bool = false

var current_level_index: int = 0

func _ready():

	# KLUCZOWA POPRAWKA: Łączenie się z globalnym sygnałem
	Signals.tile_rotated.connect(_on_tile_rotated)

	load_level(current_level_index)

func initialize_grid(tile_configs: Array): # Teraz przyjmuje argument
	if not tile_scene:
		push_error("Błąd: Tile Scene nie jest przypisana!")
		return

	grid.resize(grid_size.x)
	for x in grid_size.x:
		grid[x] = []
		grid[x].resize(grid_size.y)
		
	# Tworzenie kafelków na podstawie konfiguracji
	for config in tile_configs:
		var x = config[0]
		var y = config[1]
		var type = config[2] as CableTile.CableType
		var _rotation = config[3]

		var tile_instance: CableTile = tile_scene.instantiate()
		tile_container.add_child(tile_instance)
		
		tile_instance.position = Vector2(x * tile_size, y * tile_size)
		tile_instance.grid_position = Vector2i(x, y)
		
		# Ustawienie stanu kafelka na podstawie danych poziomu
		tile_instance.cable_type = type
		tile_instance.rotation_step = _rotation
		tile_instance.sprite.rotation_degrees = _rotation * 90 # Wizualna aktualizacja
		
		grid[x][y] = tile_instance

func load_level(index: int):
	# Sprawdzenie zakresu poziomu
	if index < 0 or index >= LEVEL_DATA.size():
		print("Błąd: Próba załadowania nieistniejącego poziomu!")
		return

	current_level_index = index
	var level_data = LEVEL_DATA[index]

	# Ustawianie rozmiaru
	grid_size = level_data.size
	
	# FIX: Jawne rzutowanie tablic na oczekiwany typ Array[Vector2i].
	# To rozwiązuje błąd typowania (Trying to assign an array of type "Array" 
	# to a variable of type "Array[Vector2i]").
	source_positions = level_data.source as Array[Vector2i]
	target_positions = level_data.target as Array[Vector2i]

	# 1. Resetowanie i usuwanie starej planszy
	if tile_container:
		for child in tile_container.get_children():
			child.queue_free()
	grid.clear()
	
	# 2. Inicjalizacja nowej siatki z danymi poziomu
	# Wymaga, aby funkcja initialize_grid(tile_configs: Array) istniała.
	initialize_grid(level_data.tiles)

	# 3. Uruchomienie logiki gry
	start_game()

func start_game():
	is_game_active = true
	# Nie robimy już losowego generowania. Logika pozostaje czysta:
	recalculate_power_flow()

# POPRAWKA: Dodano podkreślenie, aby zignorować nieużywany parametr (GRID_POS)
func _on_tile_rotated(_grid_pos: Vector2i):
	if is_game_active:
		recalculate_power_flow()

func get_tile(pos: Vector2i) -> CableTile:
	if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
		return null
	return grid[pos.x][pos.y]

func recalculate_power_flow():
	# 1. Reset stanu zasilania
	var tiles_to_check: Array[Vector2i] = []
	
	for x in grid_size.x:
		for y in grid_size.y:
			var tile: CableTile = grid[x][y]
			tile.set_power_state(false, [])
			
	# Inicjalizuj BFS od źródeł
	for source_pos in source_positions:
		var source_tile: CableTile = get_tile(source_pos)
		if source_tile:
			tiles_to_check.append(source_pos)

	var powered_tiles_set: Dictionary = {}

	# 2. Algorytm Przeszukiwania Wszerz (BFS)
	while !tiles_to_check.is_empty():
		var current_pos: Vector2i = tiles_to_check.pop_front()
		var current_tile: CableTile = get_tile(current_pos)
		
		if powered_tiles_set.has(current_pos):
			continue

		powered_tiles_set[current_pos] = true
		current_tile.set_power_state(true, [])

		var connections = current_tile.get_connections()

		for connection_dir in connections:
			var neighbor_pos = current_pos + connection_dir
			var neighbor_tile: CableTile = get_tile(neighbor_pos)

			if neighbor_tile and not powered_tiles_set.has(neighbor_pos):
				# KLUCZOWA WERYFIKACJA: Sprawdź, czy sąsiad ma port wejściowy
				var incoming_dir = -connection_dir 
				
				if neighbor_tile.get_connections().has(incoming_dir):
					tiles_to_check.push_back(neighbor_pos)
	
	# 3. Sprawdzenie warunku zwycięstwa
	check_win_condition(powered_tiles_set)

func check_win_condition(powered_tiles_set: Dictionary):
	if not is_game_active:
		return
		
	var all_targets_powered = true
	for target_pos in target_positions:
		if not powered_tiles_set.has(target_pos):
			all_targets_powered = false
			break
	
	if all_targets_powered:
		game_won()

func game_won():
	is_game_active = false
	print("WYGRANA! Wszystkie wyjścia są zasilone!")
