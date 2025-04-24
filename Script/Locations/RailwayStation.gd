extends Node2D

@onready var l1: PointLight2D = $Passage/Enter1/PointLight2D
@onready var l2: PointLight2D = $Passage/Enter2/PointLight2D
@onready var l3: PointLight2D = $Passage/Enter3/PointLight2D

func _ready() -> void:
	l1.hide()
	l2.hide()
	l3.hide()

func _on_enter_1_mouse_entered() -> void:
	l1.show()


func _on_enter_1_mouse_exited() -> void:
	l1.hide()


func _on_enter_2_mouse_entered() -> void:
	l2.show()


func _on_enter_2_mouse_exited() -> void:
	l2.hide()


func _on_enter_3_mouse_entered() -> void:
	l3.show()


func _on_enter_3_mouse_exited() -> void:
	l3.hide()
