extends Node2D

@export_category("Symbols")
@export var symbol_spot: Sprite2D
@export var symbol_swap_time: float = 1
@export var symbol_restart_time: float = 2
@export var symbols: Dictionary[int,CompressedTexture2D]
@export var number_of_symbols_per_level: Array[int] = []
@export var blink_duration: float = 0.4 
@export var blink_speed: float = 0.1

@export var panel: NinePatchRect
@export var grid: GridContainer
@export var _timer: Timer

var current_level = 1
var sequence: Array[int] = []
var player_sequence: Array[int] = [] 
var player_sequence_header: int = 0

var is_computers_turn: bool = false

const SIZE:int = 32

func _ready() -> void:
	Signals.simon_button_is_pressed.connect(add_symbol_to_player_sequence)
	randomize_sequence()

func set_panel_size()->void:
	panel.custom_minimum_size.y = SIZE * current_level + SIZE
	var i: int = 0
	var symbols_to_show = number_of_symbols_per_level[min(current_level-1, number_of_symbols_per_level.size() - 1)]
	
	for c in grid.get_children():
		var cc = c as TextureRect
		
		if cc and cc.texture is AtlasTexture:
			var atlas_texture = cc.texture as AtlasTexture
			var new_region = atlas_texture.region
			new_region.position.x = 0
			atlas_texture.region = new_region
		
		if cc:
			cc.visible = i < symbols_to_show
		
		i += 1

func update_symbol(id: int, size:int) -> void:
	if id <= 0 or id > grid.get_child_count():
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
	_timer.stop()
	is_computers_turn = true
	player_sequence_header = 0
	player_sequence.clear()
	sequence.clear()
	set_panel_size()
	
	var level_index = min(current_level - 1, number_of_symbols_per_level.size() - 1)
	var length = number_of_symbols_per_level[level_index]
	
	var last_symbol: int = -1 
	var new_symbol: int
	
	for _i in range(length):
		while true:
			new_symbol = randi_range(1, symbols.size())
			if new_symbol != last_symbol:
				break
		
		sequence.append(new_symbol)
		last_symbol = new_symbol
	
	if length > 1 and sequence[0] == sequence.back():
		var first_symbol = sequence[0]
		var second_to_last_symbol = sequence[length - 2]
		
		var new_last_symbol
		while true:
			new_last_symbol = randi_range(1, symbols.size())
			if new_last_symbol != first_symbol and new_last_symbol != second_to_last_symbol:
				sequence[-1] = new_last_symbol
				break
	display_symbol_loop() 

func add_symbol_to_player_sequence(_symbol: int)->void:
	
	if player_sequence_header >= sequence.size() or _symbol != sequence[player_sequence_header]:
		randomize_sequence()
		return
	
	player_sequence.append(_symbol)
	player_sequence_header += 1

	update_symbol(player_sequence_header,SIZE)
	
	if player_sequence_header == sequence.size():
		if current_level == 3: _finish()
		current_level+=1
		randomize_sequence()

func _finish() -> void:
	State.state_number = 26
	State.state_phase = 0
	Signals.finish_simon_mini_game.emit()
	self.queue_free()

func display_symbol_loop()->void:
	is_computers_turn = true
    
	while is_computers_turn:
		symbol_spot.show() 
        
		for s in sequence:
			if not is_computers_turn:
				symbol_spot.texture = null
				return

			symbol_spot.texture = symbols.get(s)
			symbol_spot.visible = true 

			var solid_time = symbol_swap_time - blink_duration
            
			if solid_time > 0:
				_timer.wait_time = solid_time
				_timer.start()
				await _timer.timeout
				if not is_computers_turn:
					symbol_spot.texture = null
					return
            
			var blink_elapsed: float = 0.0
			var current_visible_state = false
			while blink_elapsed < blink_duration:
				if not is_computers_turn:
					symbol_spot.texture = null
					return

				symbol_spot.visible = current_visible_state
				current_visible_state = not current_visible_state 

				var wait_time = min(blink_speed, blink_duration - blink_elapsed)
				_timer.wait_time = wait_time
				_timer.start()
				await _timer.timeout
				
				blink_elapsed += wait_time

			symbol_spot.visible = true 
			symbol_spot.texture = null
			if not is_computers_turn: return

			_timer.wait_time = symbol_restart_time
			_timer.start()
			await _timer.timeout