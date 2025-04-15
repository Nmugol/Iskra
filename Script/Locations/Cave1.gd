extends Node2D

@onready var light = $Node2D/PointLight2D

func _ready() -> void:
	light.hide()

func _on_node_2d_mouse_entered() -> void:
	light.show()


func _on_node_2d_mouse_exited() -> void:
	light.hide()
