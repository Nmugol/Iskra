class_name ShowPointLight

extends PointLight2D


@export var ParenArea: Area2D

func _ready() -> void:
	
	self.hide()
	
	ParenArea.mouse_entered.connect(func():
		# czekanie na aktualizacje flag
		for i in 2: await get_tree().process_frame
		
		if State.LevelIsLoad and State.IsRun:
			self.show()
		)
	
	ParenArea.mouse_exited.connect(func ():
		self.hide()
		)
