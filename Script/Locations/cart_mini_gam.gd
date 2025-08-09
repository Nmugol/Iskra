extends Node2D

var coalpit_level: int = 0
var start_cart: bool = false
var mini_game_is_run: bool = false

var main_cart: Cart

@onready var level1 = $Node2D/Level1
@onready var level2 = $Node2D/Level2
@onready var level3 = $Node2D/Level3
@export var cart_position_1 
@export var cart_position_2 

func _ready() -> void:
	
	Signals.reset_cursor.emit()
	State.is_running = false
	
	level1.show()
	level2.hide()
	level3.hide()
	
	Signals.cart_game_timer_on.connect(func (): 
		$Timer.wait_time = 0.6
		$Timer.one_shot = true
		$Timer.start()
		)
	Signals.cart_game_timer_off.connect(func ():
		$Timer.stop()
	)
	
	Signals.get_cart.connect(func (c: Cart):
		main_cart = c
		)


func _on_timer_timeout() -> void:
	match coalpit_level:
		0:
			return
		1:
			_load_next_mini_game_level([level1, level3], level2, cart_position_1)
		2:
			_load_next_mini_game_level([level1, level2], level3, cart_position_2)
		3:
			Signals.finish_cart_game.emit()
			self.hide()
			self.queue_free()
		_:
			Signals.load_cart_game.emit()
			self.queue_free()

func _load_next_mini_game_level(level_to_hide: Array[Node2D], level_to_show:Node2D, cart_position_mark: Marker2D) -> void:
	for l in level_to_hide:
		l.hide()
	
	level_to_show.show()
	Signals.reparent_cart.emit()
	Signals.set_cart_pos.emit(cart_position_mark.global_position)
	level_to_show.cart = main_cart
	level_to_show._update_cart()
	mini_game_is_run = false

func _process(_delta: float) -> void:
	if mini_game_is_run: return
	if start_cart and Input.is_action_just_pressed("MovePlayer"):
		Signals.cart_go.emit()
		mini_game_is_run = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	coalpit_level = 1

func _on_start_cart_mouse_entered() -> void:
	Signals.set_cursor.emit(State.Cursors.USE)
	start_cart = true

func _on_start_cart_mouse_exited() -> void:
	Signals.reset_cursor.emit()
	start_cart = false

func _on_finish_2_body_entered(_body: Node2D) -> void:
	coalpit_level = 2


func _on_texture_button_pressed() -> void:
	Signals.load_cart_game.emit()
	self.queue_free()

func _on_finish_3_body_entered(_body: Node2D) -> void:
	coalpit_level = 3
