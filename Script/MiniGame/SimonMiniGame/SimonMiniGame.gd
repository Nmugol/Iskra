extends Node2D

@export_category("Symbols")
@export var symbol_spot: Sprite2D
@export var symbol_swap_time: float = 1
@export var symbol_restart_time: float = 2
@export var symbols: Dictionary[int,CompressedTexture2D]
@export var number_of_symbols_per_level: Array[int] = []

@export var panel: NinePatchRect
@export var grid: GridContainer

var current_level = 1
var sequence: Array[int] = []
var player_sequence: Array[int] = [] 
var player_sequence_header: int = 0

var symbols_is_displaying: bool = false

const SIZE:int = 32

func _ready() -> void:
	Signals.simon_button_is_pressed.connect(add_symbol_to_player_sequence)

	randomize_sequence()

func set_panel_size()->void:
	panel.custom_minimum_size.y = SIZE * current_level + SIZE
	var i: int = 0
	var symbols_to_show = number_of_symbols_per_level[min(current_level-1,2)]
	
	for c in grid.get_children():
		var cc = c as TextureRect
		
		if cc and cc.texture is AtlasTexture:
			var atlas_texture = cc.texture as AtlasTexture
			
			var new_region = atlas_texture.region
			new_region.position.x = 0
			atlas_texture.region = new_region
		
		if cc:
			if i < symbols_to_show:
				cc.show()
			else:
				cc.hide()
		
		i += 1

func update_symbol(id: int, size:int) -> void:
	if id < 0 or id >= grid.get_child_count():
		return 

	var symbol_node = grid.get_child(id-1)

	if symbol_node is TextureRect:
		var sprite = symbol_node as TextureRect
		if sprite.texture is AtlasTexture:
			var atlas_texture = sprite.texture as AtlasTexture
			
			var new_region = atlas_texture.region
			new_region.position.x = size
			atlas_texture.region = new_region

func randomize_sequence() -> void:
	symbols_is_displaying = true
	player_sequence_header = 0
	player_sequence.clear()
	sequence.clear()
	set_panel_size()
	
	var level_index = min(current_level - 1, number_of_symbols_per_level.size() - 1)
	var length = number_of_symbols_per_level[level_index]
	
	var last_symbol: int = -1 
	var new_symbol: int = 0
	
	for _i in range(length):
		while true:
			new_symbol = randi_range(1, symbols.size())
			if new_symbol != last_symbol:
				break
		
		sequence.append(new_symbol)
		last_symbol = new_symbol
		
	display_symbol() 
	print(sequence)

func add_symbol_to_player_sequence(_symbol: int)->void:

	if _symbol != sequence[player_sequence_header]:
		randomize_sequence()
		return
	
	player_sequence.append(_symbol)
	player_sequence_header += 1

	update_symbol(player_sequence_header,SIZE)
	
	if player_sequence_header == sequence.size():
		if current_level == 3:
			print("win")
			return
		current_level+=1
		randomize_sequence()
	
func display_symbol()->void:
	symbols_is_displaying = true
	
	for s in sequence:
		symbol_spot.texture = symbols.get(s)
		await get_tree().create_timer(symbol_swap_time).timeout
	await get_tree().create_timer(symbol_restart_time).timeout

	symbols_is_displaying = false
	display_symbol()
