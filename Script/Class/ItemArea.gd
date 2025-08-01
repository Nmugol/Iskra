extends Area2D

@export var area_name: String
@export var active_on: Array[int] = []

func _ready() -> void:
	
	if State.state_number not in active_on: self.queue_free()
	
	
	self.mouse_entered.connect(func ():
		Signals.mouse_above_item.emit(area_name)
		Signals.set_cursor.emit(State.Cursors.PICKUP)
		)
	
	self.mouse_exited.connect(func():
		Signals.mouse_off_item.emit()
		Signals.reparent_cart.emit()
		)
