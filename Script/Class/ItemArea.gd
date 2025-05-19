extends Area2D

@export var aree_name: String

func _ready() -> void:
	self.mouse_entered.connect(func ():
		Signals.mouse_above_item.emit(aree_name)
		)
	
	self.mouse_exited.connect(func():
		Signals.mouse_off_item.emit()
		)
