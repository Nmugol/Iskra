class_name Track
extends Node2D

const SPEED = 5

@export var attach: Area2D
@export var cart: Cart
@export var attach_to: PathFollow2D

@export var flip_x: bool
@export var flip_y: bool

var attach_flag:bool = false

func _ready() -> void:
	attach.body_entered.connect(func (body:Node2D):
		if body.is_in_group("Cart"):
			var paren = cart.get_parent()
			paren.remove_child(cart)
			attach_to.add_child(cart)
			
			attach_to.progress_ratio = 0
			attach_flag = true
		)

func _process(delta: float) -> void:
	if attach_flag:
		attach_to.progress_ratio = move_toward(attach_to.progress_ratio, 1, SPEED*delta)
	
	if flip_x:
		self.scale.x = -1
	else:
		self.scale.x = 1
	
	if flip_y:
		self.scale.y = -1
	else:
		self.scale.y = 1
