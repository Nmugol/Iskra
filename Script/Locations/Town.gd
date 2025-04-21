extends Node2D

func _ready() -> void:
	$Passage/Mines1/PointLight2D.hide()
	$Passage/Mines2/PointLight2D.hide()



func _on_mines_1_mouse_entered() -> void:
	$Passage/Mines1/PointLight2D.show()


func _on_mines_1_mouse_exited() -> void:
	$Passage/Mines1/PointLight2D.hide()


func _on_mines_2_mouse_entered() -> void:
	$Passage/Mines2/PointLight2D.show()


func _on_mines_2_mouse_exited() -> void:
	$Passage/Mines2/PointLight2D.hide()
