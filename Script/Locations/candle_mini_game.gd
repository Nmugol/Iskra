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

func _ready() -> void:
	candle.global_position = candle_center.global_position

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
