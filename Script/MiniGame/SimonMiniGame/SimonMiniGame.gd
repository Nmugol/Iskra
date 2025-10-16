extends Node2D

@export_category("Symbols")
@export var symbol_spot: Sprite2D
@export var symbol_swap_time: float = 1
@export var symbol_restart_time: float = 2 # Czas przed powtórzeniem sekwencji
@export var symbols: Dictionary[int,CompressedTexture2D]
@export var number_of_symbols_per_level: Array[int] = []

@export var panel: NinePatchRect
@export var grid: GridContainer
@export var _timer: Timer

var current_level = 1
var sequence: Array[int] = []
var player_sequence: Array[int] = [] 
var player_sequence_header: int = 0

# Ta zmienna kontroluje teraz, czy komputer jest w trakcie pokazywania sekwencji
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
	# POPRAWKA: Pierwsze kliknięcie gracza przerywa pętlę komputera
	if is_computers_turn:
		is_computers_turn = false
		_timer.stop()
	
	if player_sequence_header >= sequence.size() or _symbol != sequence[player_sequence_header]:
		randomize_sequence()
		return
	
	player_sequence.append(_symbol)
	player_sequence_header += 1

	update_symbol(player_sequence_header,SIZE)
	
	if player_sequence_header == sequence.size():
		if current_level == 3:
			return
		current_level+=1
		randomize_sequence()

# POPRAWKA: Ta funkcja teraz działa w pętli, powtarzając sekwencję
func display_symbol_loop()->void:
	is_computers_turn = true
	
	while is_computers_turn:
		# Pokaż całą sekwencję raz
		symbol_spot.show()
		for s in sequence:
			# Jeśli gracz przerwał w trakcie, zakończ natychmiast
			if not is_computers_turn:
				symbol_spot.texture = null
				return

			symbol_spot.texture = symbols.get(s)
			_timer.wait_time = symbol_swap_time
			_timer.start()
			await _timer.timeout
		
		# Wyczyść symbol po pokazaniu sekwencji
		symbol_spot.texture = null
		
		# Jeśli gracz przerwał zaraz po, zakończ
		if not is_computers_turn:
			return
		
		# Poczekaj przed ponownym wyświetleniem
		_timer.wait_time = symbol_restart_time
		_timer.start()
		await _timer.timeout