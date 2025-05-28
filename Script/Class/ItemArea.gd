extends Area2D

@export var aree_name: String

func _ready() -> void:
	self.mouse_entered.connect(func ():
		Signals.mouse_above_item.emit(aree_name)
		Signals.set_coursor.emit(State.Coursors.PICKUP)
		)
	
	self.mouse_exited.connect(func():
		Signals.mouse_off_item.emit()
		Signals.reparent_cart.emit()
		)
