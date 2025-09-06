extends Node2D

@export var move_distance: float = 0.5
@export var rotate_speed: float = 30.0  # Added rotation speed

@onready var candle: Sprite2D = $Candle
@onready var cristal: Sprite2D = $Cristal

@onready var max_candle_left: Marker2D = $CandleContainer/MaxLeft
@onready var max_candle_right: Marker2D = $CandleContainer/MaxRight
@onready var max_candle_top: Marker2D = $CandleContainer/MaxUp
@onready var max_candle_bottom: Marker2D = $CandleContainer/MaxDown
@onready var candle_center: Marker2D = $CandleContainer/Center

@onready var level_1: Node2D = $CentralZone/Symbols/Level1
@onready var level_2: Node2D = $CentralZone/Symbols/Level2
@onready var level_3: Node2D = $CentralZone/Symbols/Level3

@onready var symbol_counter: RichTextLabel = $Control/SymbolCounter/MarginContainer/RichTextLabel


@export var symbols_in_level_one: Array[Symbol] = []
@export var symbols_in_level_two: Array[Symbol] = []
@export var symbols_in_level_three: Array[Symbol] = []

var current_symbols: Array[Symbol] = []

enum above_button {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	ROT_LEFT,
	ROT_RIGHT,
	NONE
}

var cursor_above_button: above_button = above_button.NONE

var compleat_symbols: int = 0

var current_level: int = 1

var level_one_completed_count: int = 2
var level_two_completed_count: int = 2
var level_three_completed_count: int = 4

var change_level: bool = false

func _ready() -> void:
	candle.global_position = candle_center.global_position	
	level_1.show()
	level_2.hide()
	level_3.hide()
	current_symbols = symbols_in_level_one
	check_symbol_position()
	show_symbols()

func _process(delta: float) -> void:

	if cursor_above_button == above_button.NONE: 
		Signals.reset_cursor.emit()
		Signals.stop_moving_and_rotate_symbol.emit()
	else: Signals.set_cursor.emit(State.Cursors.USE)	

	if Input.is_action_pressed("MovePlayer"):
		match cursor_above_button:
			above_button.UP: move_up()
			above_button.DOWN: move_down()
			above_button.LEFT: move_left()
			above_button.RIGHT: move_right()
			above_button.ROT_LEFT:
				cristal.global_rotation += deg_to_rad(rotate_speed) * delta
				Signals.rotate_symbol.emit(true)
			above_button.ROT_RIGHT: 
				cristal.global_rotation += deg_to_rad(-rotate_speed) * delta
				Signals.rotate_symbol.emit(false)

	if Input.is_action_just_released("MovePlayer"):
		Signals.stop_moving_and_rotate_symbol.emit()

	check_symbol_position()
	check_level_completion()

func check_symbol_position() -> void:
	var count = 0
	
	for symbol in current_symbols:
		if symbol.in_target:
			count += 1 
	compleat_symbols = count
	
	symbol_counter.text = "%d / %d [img=16x16]res://Sprite/symbols/linked_symbols.png[/img]" % [count, current_symbols.size()]

	
	

func check_level_completion() -> void:
	if compleat_symbols == level_one_completed_count and current_level == 1:
		change_level = true
		compleat_symbols = 0  # Reset immediately
		await get_tree().create_timer(0.2).timeout
		current_level = 2
		level_1.hide()
		level_2.show()
		level_3.hide()
		current_symbols = symbols_in_level_two
		show_symbols()
		_on_texture_button_pressed() # Reset symbols and candle position
		candle.global_position = candle_center.global_position
		cristal.global_rotation = 0.0
		change_level = false
		return

	if compleat_symbols == level_two_completed_count and current_level == 2:
		change_level = true
		compleat_symbols = 0  # Reset immediately
		await get_tree().create_timer(0.2).timeout
		current_level = 3
		level_1.hide()
		level_2.hide()
		level_3.show()
		current_symbols = symbols_in_level_three
		show_symbols()
		_on_texture_button_pressed() # Reset symbols and candle position
		candle.global_position = candle_center.global_position
		cristal.global_rotation = 0.0
		change_level = false
		return
	
	if compleat_symbols == level_three_completed_count and current_level == 3:
		print("Game Completed")
		return

func show_symbols() -> void:
	for symbol in current_symbols:
		symbol.show()
		symbol.is_active = true

# Fixed movement functions with proper boundary checks
func move_left() -> void:
	var target_x = candle.global_position.x - move_distance
	candle.global_position.x = clamp(target_x, max_candle_left.global_position.x, max_candle_right.global_position.x)
	
	if candle.global_position.x == max_candle_left.global_position.x or candle.global_position.x == max_candle_right.global_position.x:
		Signals.stop_moving_and_rotate_symbol.emit()
	else:
		Signals.symbol_move_on_x_axis.emit(true)

func move_right() -> void:
	var target_x = candle.global_position.x + move_distance
	candle.global_position.x = clamp(target_x, max_candle_left.global_position.x, max_candle_right.global_position.x)
	
	if candle.global_position.x == max_candle_left.global_position.x or candle.global_position.x == max_candle_right.global_position.x:
		Signals.stop_moving_and_rotate_symbol.emit()
	else:
		Signals.symbol_move_on_x_axis.emit(false)

func move_up() -> void:
	var target_y = candle.global_position.y - move_distance
	candle.global_position.y = clamp(target_y, max_candle_top.global_position.y, max_candle_bottom.global_position.y)

	if candle.global_position.y == max_candle_top.global_position.y or candle.global_position.y == max_candle_bottom.global_position.y:
		Signals.stop_moving_and_rotate_symbol.emit()
	else:
		Signals.symbol_move_on_y_axis.emit(true)

func move_down() -> void:
	var target_y = candle.global_position.y + move_distance
	candle.global_position.y = clamp(target_y, max_candle_top.global_position.y, max_candle_bottom.global_position.y)
	
	if candle.global_position.y == max_candle_top.global_position.y or candle.global_position.y == max_candle_bottom.global_position.y:
		Signals.stop_moving_and_rotate_symbol.emit()
	else:
		Signals.symbol_move_on_y_axis.emit(false)

# Signal handlers with corrected variable names
func _on_rotate_to_right_mouse_entered() -> void:
	cursor_above_button = above_button.ROT_RIGHT

func _on_rotate_to_right_mouse_exited() -> void:
	cursor_above_button = above_button.NONE

func _on_rotate_to_left_mouse_entered() -> void:
	cursor_above_button = above_button.ROT_LEFT

func _on_rotate_to_left_mouse_exited() -> void:
	cursor_above_button = above_button.NONE

func _on_left_mouse_entered() -> void:
	cursor_above_button = above_button.LEFT

func _on_left_mouse_exited() -> void:
	cursor_above_button = above_button.NONE

func _on_up_mouse_entered() -> void:
	cursor_above_button = above_button.UP

func _on_up_mouse_exited() -> void:
	cursor_above_button = above_button.NONE

func _on_down_mouse_entered() -> void:
	cursor_above_button = above_button.DOWN

func _on_down_mouse_exited() -> void:
	cursor_above_button = above_button.NONE

func _on_right_mouse_entered() -> void:
	cursor_above_button = above_button.RIGHT

func _on_right_mouse_exited() -> void:
	cursor_above_button = above_button.NONE


func _on_texture_button_pressed() -> void:

	for symbol in current_symbols:
		symbol.set_up()
	candle.global_position = candle_center.global_position
	cristal.global_rotation = 0.0
	compleat_symbols = 0
