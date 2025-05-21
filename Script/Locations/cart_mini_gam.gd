extends Node2D

var Complit: bool = false
var StartCart: bool = false
var minigame_is_run: bool = false

func _ready() -> void:
	Signals.cart_game_timer_on.connect(func (): 
		$Timer.wait_time = 0.6
		$Timer.one_shot = true
		$Timer.start()
		)
	Signals.cart_game_timer_off.connect(func ():
		$Timer.stop()
	)


func _on_timer_timeout() -> void:
	if Complit:
		print("level complite") 
		return
	Signals.load_cart_game.emit()
	self.queue_free()

func _process(delta: float) -> void:
	if minigame_is_run: return
	if StartCart and Input.is_action_just_pressed("MovePlayer"):
		Signals.cart_go.emit()
		minigame_is_run = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	Complit = true


func _on_start_cart_mouse_entered() -> void:
	StartCart = true


func _on_start_cart_mouse_exited() -> void:
	StartCart = false
