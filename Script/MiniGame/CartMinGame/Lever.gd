class_name Lever
extends Node2D

@export_category("Tracks")
@export var track_to_rotate: Array[Track] = []
@export var track_to_flip_x: Array[Track] = []
@export var track_to_flip_y: Array[Track] = []

@export_category("Audio")
@export var lever_sfx: AudioStream

@onready var sprite: AnimatedSprite2D = $Sprite2D

var mouse_on: bool = false
var mini_game_is_running: bool = false
var lever_finish: bool = true

func _rotate()-> void:
	if track_to_rotate.is_empty(): return
	for t in track_to_rotate:
		t.global_rotation_degrees += 90
		if t.global_rotation_degrees == 360:
			t.global_rotation_degrees = 0

func _flip_x()-> void:
	if track_to_flip_x.is_empty(): return
	for t in track_to_flip_x:
		t.flip_x = !t.flip_x
		t.update_scale()

func _flip_y()-> void:
	if track_to_flip_y.is_empty(): return
	for t in track_to_flip_y:
		t.flip_y = !t.flip_y
		t.update_scale()

func _ready() -> void:
	set_up()

	Signals.cart_go.connect(func (): mini_game_is_running = true)
	Signals.reparent_cart.connect(func (): mini_game_is_running = false)

func _process(_delta: float) -> void:
	if mini_game_is_running: return
	if mouse_on and Input.is_action_just_pressed("MovePlayer") and lever_finish:
		lever_finish = false
		_rotate()
		_flip_x()
		_flip_y()
		sprite.play("use")
		Signals.play_sound.emit(State.AudioType.Effect, lever_sfx, randf_range(0.8, 1.2), -15)
		await sprite.animation_finished
		lever_finish = true
		sprite.play("normal")
		

func _on_area_2d_mouse_entered() -> void:
	Signals.set_cursor.emit(State.Cursors.USE)
	mouse_on = true

func _on_area_2d_mouse_exited() -> void:
	Signals.reset_cursor.emit()
	mouse_on = false

func set_up() -> void:
	track_to_flip_x = []
	track_to_flip_y = []
	track_to_rotate = []
	lever_finish = true
	mini_game_is_running = false
