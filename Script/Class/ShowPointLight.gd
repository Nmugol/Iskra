class_name ShowPointLight

extends PointLight2D


@export var paren_area: Area2D

func _ready() -> void:
	
	self.hide()
	
	paren_area.mouse_entered.connect(func():
		if not State.is_loading and State.is_running:
			self.show()
		)
	
	paren_area.mouse_exited.connect(func ():
		self.hide()
		)
