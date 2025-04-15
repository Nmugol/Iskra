extends Node2D

@onready var light = $EntranceToTheMine/PointLight2D

func _ready() -> void:
	light.hide()

func _on_entrance_to_the_mine_mouse_entered() -> void:
	light.show()

func _on_entrance_to_the_mine_mouse_exited() -> void:
	light.hide()
