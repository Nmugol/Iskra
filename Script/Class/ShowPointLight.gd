class_name ShowPointLight

extends PointLight2D


@export var ParenArea: Area2D

func _ready() -> void:
	
	self.hide()
	
	ParenArea.mouse_entered.connect(func():
		self.show()
		)
	
	ParenArea.mouse_exited.connect(func ():
		self.hide()
		)
