class_name Cart
extends CharacterBody2D

@export var main_parent: Node2D

func _ready() -> void:
	Signals.cart_go.connect(func ():
		self.position.y -= 6
		)
	
	Signals.set_cart_pos.connect(func (pos:Vector2):
		self.global_position = pos
		self.show()
		)
	
	Signals.reparent_cart.connect(_back_to_main_parent)

func _back_to_main_parent() -> void:
	get_parent().remove_child(self)
	main_parent.add_child(self)
	Signals.get_cart.emit(self)
