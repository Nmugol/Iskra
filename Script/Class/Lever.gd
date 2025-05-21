class_name Lever
extends Node2D

@export var track_to_rotate: Array[Track] = []
@export var track_to_flip_x: Array[Track] = []
@export var track_to_flip_y: Array[Track] = []

@onready var sprite: AnimatedSprite2D = $Sprite2D

var mous_on: bool = false

func _rotate()-> void:
	if track_to_rotate.is_empty(): return
	for t in track_to_rotate:
		t.global_rotation_degrees += 90
		if t.global_rotation_degrees == 360:
			t.global_rotation_degrees = 0

func _flio_x()-> void:
	if track_to_flip_x.is_empty(): return
	for t in track_to_flip_x:
		t.flip_x = !t.flip_x
		t.update_scale()

func _flio_y()-> void:
	if track_to_flip_y.is_empty(): return
	for t in track_to_flip_y:
		t.flip_y = !t.flip_y
		t.update_scale()

func _process(_delta: float) -> void:
	if mous_on and Input.is_action_just_pressed("MovePlayer"):
		_rotate()
		_flio_x()
		_flio_y()
		sprite.play("use")
		await sprite.animation_finished
		sprite.play("normal")

func _on_area_2d_mouse_entered() -> void:
	mous_on = true

func _on_area_2d_mouse_exited() -> void:
	mous_on = false
