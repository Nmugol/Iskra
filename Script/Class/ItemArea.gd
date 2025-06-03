extends Area2D

@export var aree_name: String
@export var actibe_on: Array[int] = []

func _ready() -> void:
	
	if State.StateNumber not in actibe_on: self.queue_free()
	
	
	self.mouse_entered.connect(func ():
		Signals.mouse_above_item.emit(aree_name)
		Signals.set_coursor.emit(State.Coursors.PICKUP)
		)
	
	self.mouse_exited.connect(func():
		Signals.mouse_off_item.emit()
		Signals.reparent_cart.emit()
		)
