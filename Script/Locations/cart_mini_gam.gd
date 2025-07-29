extends Node2D

var Complit_Level: int = 0
var StartCart: bool = false
var minigame_is_run: bool = false

var main_cart: Cart

func _ready() -> void:
	
	Signals.reset_coursor.emit()
	
	$Node2D/Leve1.show()
	$Node2D/Leve2.hide()
	$Node2D/Leve3.hide()
	
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
	match Complit_Level:
		0:
			return
		1:
			_load_next_mingagame_level([$Node2D/Leve1, $Node2D/Leve3], $Node2D/Leve2, $Node2D/Leve2/Marker2D)
		2:
			_load_next_mingagame_level([$Node2D/Leve1, $Node2D/Leve2], $Node2D/Leve3, $Node2D/Leve3/Marker2D)
		3:
			Signals.finish_cart_game.emit()
			self.hide()
			self.queue_free()
		_:
			Signals.load_cart_game.emit()
			self.queue_free()

func _load_next_mingagame_level(level_to_hide: Array[Node2D], level_to_show:Node2D, cart_position_mark: Marker2D) -> void:
	for l in level_to_hide:
		l.hide()
	
	level_to_show.show()
	Signals.reparent_cart.emit()
	Signals.set_cart_pos.emit(cart_position_mark.global_position)
	level_to_show.cart = main_cart
	level_to_show._update_cart()
	minigame_is_run = false

func _process(_delta: float) -> void:
	if minigame_is_run: return
	if StartCart and Input.is_action_just_pressed("MovePlayer"):
		Signals.cart_go.emit()
		minigame_is_run = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	Complit_Level = 1

func _on_start_cart_mouse_entered() -> void:
	Signals.set_coursor.emit(State.Coursors.USE)
	StartCart = true

func _on_start_cart_mouse_exited() -> void:
	Signals.reset_coursor.emit()
	StartCart = false

func _on_finish_2_body_entered(_body: Node2D) -> void:
	Complit_Level = 2


func _on_texture_button_pressed() -> void:
	Signals.load_cart_game.emit()
	self.queue_free()

func _on_finish_3_body_entered(_body: Node2D) -> void:
	Complit_Level = 3
