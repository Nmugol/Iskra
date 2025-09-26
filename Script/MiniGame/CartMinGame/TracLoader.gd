extends Node2D

@export var cart: Cart

var signal_is_emited: bool = false

@export_category("Lever 1")
@export var track_to_rotate_L1: Array[Track] = []
@export var track_to_flip_on_x_L1: Array[Track] = []
@export var track_to_flip_on_y_L1: Array[Track] = []

@export_category("Lever 2")
@export var track_to_rotate_L2: Array[Track] = []
@export var track_to_flip_on_x_L2: Array[Track] = []
@export var track_to_flip_on_y_L2: Array[Track] = []

@export_category("Lever 3")
@export var track_to_rotate_L3: Array[Track] = []
@export var track_to_flip_on_x_L3: Array[Track] = []
@export var track_to_flip_on_y_L3: Array[Track] = []

@export_category("Lever 4")
@export var track_to_rotate_L4: Array[Track] = []
@export var track_to_flip_on_x_L4: Array[Track] = []
@export var track_to_flip_on_y_L4: Array[Track] = []


func _ready() -> void:
	_update_cart()

func _update_cart()->void:
	var children = self.get_children()
	for child in children:
		if child is Track:
			child.cart = cart


func _on_finish_body_entered(_body:Node2D) -> void:
	if !signal_is_emited:
		print("finish")
		signal_is_emited = true
		Signals.increase_cart_stage.emit()
