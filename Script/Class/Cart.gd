class_name Cart
extends CharacterBody2D

func _ready() -> void:
	Signals.cart_go.connect(func ():
		self.position.y -= 6
		)
