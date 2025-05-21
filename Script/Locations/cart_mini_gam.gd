extends Node2D

var Complit: bool = false

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
	print("GameOver")


func _on_area_2d_body_entered(body: Node2D) -> void:
	Complit = true
