extends Node2D

const LEVEL_DATA = [
	#Level1
	{
		"size": Vector2i(5, 5),
		"source": [Vector2i(0, 1)], 
		"target": [Vector2i(4, 4)],
		"tiles": [
			[0,0,4,1],[1,0,4,3],[2,0,0,2],[3,0,0,1],[4,0,1,1],

			[0,1,3,1],[1,1,4,2],[2,1,5,3],[3,1,0,2],[4,1,4,2],
			
			[0,2,0,1],[1,2,0,1],[2,2,0,0],[3,2,2,3],[4,2,1,2],

			[0,3,4,0],[1,3,2,0],[2,3,0,0],[3,3,4,1],[4,3,2,3],

			[0,4,5,0],[1,4,0,2],[2,4,5,0],[3,4,4,1],[4,4,3,3],
		]
	},
	#Level2
	{
		"size": Vector2i(5, 5),
		"source": [Vector2i(0, 0),Vector2i(0,4)], 
		"target": [Vector2i(3, 1),Vector2i(4,3)],
		"tiles": [
			[0,0,0,0],[1,0,2,1],[2,0,0,0],[3,0,0,0],[4,0,1,1],

			[0,1,0,1],[1,1,0,2],[2,1,5,2],[3,1,0,1],[4,1,1,2],

			[0,2,2,2],[1,2,5,2],[2,2,4,1],[3,2,0,2],[4,2,1,3],

			[0,3,3,3],[1,3,0,0],[2,3,0,3],[3,3,1,2],[4,3,0,0],

			[0,4,0,1],[1,4,1,0],[2,4,2,0],[3,4,0,1],[4,4,1,2],
		]
	},
	#Level3
	{
		"size": Vector2i(5, 5),
		"source": [Vector2i(1, 1)], 
		"target": [Vector2i(0, 4),Vector2i(3,3), Vector2i(4,0)],
		"tiles": [
			[0,0,3,1],[1,0,1,3],[2,0,0,1],[3,0,1,0],[4,0,0,0],

			[0,1,2,0],[1,1,1,1],[2,1,0,0],[3,1,5,1],[4,1,4,1],

			[0,2,2,3],[1,2,1,0],[2,2,0,0],[3,2,3,3],[4,2,0,0],

			[0,3,0,0],[1,3,2,3],[2,3,1,0],[3,3,0,1],[4,3,1,1],

			[0,4,0,1],[1,4,0,1],[2,4,1,1],[3,4,5,1],[4,4,0,0],
		]
	},
]

@export_category("Grid Settings")
@export var grid_size: Vector2i = Vector2i(5,5)
@export var tile_scene: PackedScene 
@export var tile_size: float = 32.0
@export var tile_container: Node2D

@export_category("Energi input and output")
@export var source_positions: Array
@export var target_positions: Array

var grid: Array[Array] = []
var is_game_active: bool = false
var current_level_index: int = 0

func _ready():
	if not is_instance_valid(tile_container):
		tile_container = Node2D.new()
		tile_container.name = "TileContainer"
		add_child(tile_container)
		
	Signals.tile_rotated.connect(_on_tile_rotated)
	load_level(current_level_index)

func initialize_grid(tile_configs: Array):
	if not tile_scene:
		push_error("Błąd: Tile Scene nie jest przypisana!")
		return

	grid.resize(grid_size.x)
	for x in grid_size.x:
		grid[x] = []
		grid[x].resize(grid_size.y)

	for config in tile_configs:
		var x = config[0]
		var y = config[1]
		var type = config[2] as CableTile.CableType
		var _rotation = config[3]

		var tile_instance: CableTile = tile_scene.instantiate()
		tile_container.add_child(tile_instance)
		
		tile_instance.position = Vector2(x * tile_size, y * tile_size)
		tile_instance.grid_position = Vector2i(x, y)
		
		tile_instance.cable_type = type
		tile_instance.rotation_step = _rotation
		tile_instance.sprite.rotation_degrees = _rotation * 90 
		
		if source_positions.has(tile_instance.grid_position) or target_positions.has(tile_instance.grid_position):
			tile_instance.is_target_or_source = true
		
		tile_instance.set_bg()
		
		grid[x][y] = tile_instance

func load_level(index: int):
	if index < 0 or index >= LEVEL_DATA.size():
		print("Błąd: Próba załadowania nieistniejącego poziomu!")
		return

	current_level_index = index
	var level_data = LEVEL_DATA[index]

	grid_size = level_data.size
	
	source_positions = level_data.source
	target_positions = level_data.target

	if tile_container:
		for child in tile_container.get_children():
			child.queue_free()
	grid.clear()
	
	initialize_grid(level_data.tiles)
	start_game()

func start_game():
	is_game_active = true
	recalculate_power_flow()

func _on_tile_rotated(_grid_pos: Vector2i):
	if is_game_active:
		recalculate_power_flow()

func get_tile(pos: Vector2i) -> CableTile:
	if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y: return null
	return grid[pos.x][pos.y]

func recalculate_power_flow():
	var tiles_to_check: Array[Vector2i] = []
	var powered_tiles_info: Dictionary = {} 
	
	# 1. Resetowanie wszystkich kafelków
	for x in grid_size.x:
		for y in grid_size.y:
			var tile: CableTile = grid[x][y]
			tile.set_power_state(false, [])

	# 2. Dodanie źródeł do kolejki
	for source_pos in source_positions:
		var source_tile: CableTile = get_tile(source_pos)
		if source_tile:
			if not powered_tiles_info.has(source_pos):
				powered_tiles_info[source_pos] = [] as Array[Vector2i]
		
			if not powered_tiles_info[source_pos].has(Vector2i.ZERO):
				powered_tiles_info[source_pos].append(Vector2i.ZERO)
				tiles_to_check.push_back(source_pos)
			

	while !tiles_to_check.is_empty():
		var current_pos: Vector2i = tiles_to_check.pop_front()
		var current_tile: CableTile = get_tile(current_pos)
		
		if current_tile == null: continue
		var incoming_dirs: Array[Vector2i] = powered_tiles_info.get(current_pos, [] as Array[Vector2i]) as Array[Vector2i]
		
		current_tile.set_power_state(true, incoming_dirs)
		current_tile.set_bg()

		var all_output_directions: Array[Vector2i] = []
		for power_entered_from in incoming_dirs:
			var output_connections = current_tile.get_output_dir(power_entered_from)
			for dir in output_connections:
				if not all_output_directions.has(dir):
					all_output_directions.append(dir)

		for connection_dir in all_output_directions:
			var neighbor_pos = current_pos + connection_dir
			var neighbor_tile: CableTile = get_tile(neighbor_pos)
			
			if neighbor_tile == null: continue
			var incoming_dir_to_neighbor = -connection_dir 
			var neighbor_all_open_ports = neighbor_tile.get_output_dir(Vector2i.ZERO)
			if neighbor_all_open_ports.has(incoming_dir_to_neighbor):
				var is_new_path = false
				
				if not powered_tiles_info.has(neighbor_pos):
					powered_tiles_info[neighbor_pos] = [] as Array[Vector2i]
					is_new_path = true
				
				if not powered_tiles_info[neighbor_pos].has(incoming_dir_to_neighbor):
					powered_tiles_info[neighbor_pos].append(incoming_dir_to_neighbor)
					is_new_path = true
					
				if is_new_path:
					tiles_to_check.push_back(neighbor_pos)
	check_win_condition(powered_tiles_info.keys())

func check_win_condition(powered_tiles: Array):
	if not is_game_active: return
		
	var all_targets_powered = true
	for target_pos in target_positions:
		if not powered_tiles.has(target_pos):
			all_targets_powered = false
			break
	if all_targets_powered: game_won()

func game_won():
	is_game_active = false
	print("WYGRANA! Wszystkie wyjścia są zasilone!")
	
	var next_level_index = current_level_index + 1
	
	if next_level_index < LEVEL_DATA.size(): load_level(next_level_index)
	else: print("GRATULACJE! Ukończono wszystkie poziomy!")
