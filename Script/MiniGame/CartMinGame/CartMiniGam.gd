extends Node2D

var coalpit_level: int = 0
var start_cart: bool = false
var mini_game_is_run: bool = false

@export_category("Audio")
@export var play_button_sfx: AudioStream

@export_category("Level loader")
@export var level_loader: Node2D

@export_category("Levers")
@export var lever_1: Lever
@export var lever_2: Lever
@export var lever_3: Lever
@export var lever_4: Lever

#Levels
var level_1: PackedScene = preload("res://Scenes/MiniGame/CartMinGame/level_1.tscn")
var level_2: PackedScene = preload("res://Scenes/MiniGame/CartMinGame/level_2.tscn")
var level_3: PackedScene = preload("res://Scenes/MiniGame/CartMinGame/level_3.tscn")


func _ready() -> void:
	print(coalpit_level, " level")

	Signals.reset_cursor.emit()
	State.is_running = false

	Signals.cart_game_timer_on.connect(func (): 
		$Timer.wait_time = 0.6
		$Timer.one_shot = true
		$Timer.start()
		)
	Signals.cart_game_timer_off.connect(func ():
		$Timer.stop()
	)

	Signals.increase_cart_stage.connect(increase_coalpit_level)

	call_deferred("loading_level")

func increase_coalpit_level()-> void:
	print(coalpit_level, " level")
	coalpit_level += 1
	print(coalpit_level, " level")
	call_deferred("loading_level")

func _on_timer_timeout() -> void:
	call_deferred("loading_level")
	
func loading_level() -> void:
	$Timer.stop()
	for c in level_loader.get_children():
		c.queue_free()
	
	call_deferred("_add_level_after_clearing")

func _add_level_after_clearing () -> void:
	var level: Node = null

	match coalpit_level:
		0:
			level = level_1.instantiate()
		1:
			level = level_2.instantiate()
		2:
			level = level_3.instantiate()
		3:
			Signals.finish_cart_game.emit()
			self.hide()
			self.queue_free()
			return
	
	if level != null:
		level_loader.add_child(level)
		load_tracks(level)
	
	mini_game_is_run = false


func load_tracks(level: Node)-> void:
	lever_1.set_up()
	lever_2.set_up()
	lever_3.set_up()
	lever_4.set_up()

	lever_1.track_to_rotate = level.track_to_rotate_L1
	lever_1.track_to_flip_x = level.track_to_flip_on_x_L1
	lever_1.track_to_flip_y = level.track_to_flip_on_y_L1

	lever_2.track_to_rotate = level.track_to_rotate_L2
	lever_2.track_to_flip_x = level.track_to_flip_on_x_L2
	lever_2.track_to_flip_y = level.track_to_flip_on_y_L2

	lever_3.track_to_rotate = level.track_to_rotate_L3
	lever_3.track_to_flip_x = level.track_to_flip_on_x_L3
	lever_3.track_to_flip_y = level.track_to_flip_on_y_L3

	lever_4.track_to_rotate = level.track_to_rotate_L4
	lever_4.track_to_flip_x = level.track_to_flip_on_x_L4
	lever_4.track_to_flip_y = level.track_to_flip_on_y_L4
	

func _process(_delta: float) -> void:
	if mini_game_is_run: return
	if start_cart and Input.is_action_just_pressed("MovePlayer"):
		Signals.cart_go.emit()
		Signals.play_sound.emit(State.AudioType.Effect, play_button_sfx)
		mini_game_is_run = true

func _on_start_cart_mouse_entered() -> void:
	Signals.set_cursor.emit(State.Cursors.USE)
	start_cart = true

func _on_start_cart_mouse_exited() -> void:
	Signals.reset_cursor.emit()
	start_cart = false

func _on_texture_button_pressed() -> void:
	loading_level()
	Signals.play_sound.emit(State.AudioType.Effect, play_button_sfx, 1, -15)
