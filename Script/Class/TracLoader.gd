extends Node2D

@export var cart: Cart

func _ready() -> void:
	var children = self.get_children()
	for child in children:
		if child is Track:
			child.cart = cart
