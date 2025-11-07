extends Node2D

@export var symbol: CompressedTexture2D
@export var symbol_id: int

@onready var _sprite = $BG/Symbol

var mouse_on: bool = false

@export var background: Sprite2D
@export var MOUSE_ON_COLOR: Color
@export var MOUSE_CLICK_COLOR: Color
@export var DEFAULT_COLOR: Color
@export var DISABLE_COLOR: Color

var disable_flag: bool = false


func _ready() -> void:
	Signals.enable_buttons.connect(
		func() -> void:
			background.modulate = DEFAULT_COLOR
			disable_flag = false
			mouse_on = false
	)
	Signals.disable_buttons.connect(
		func() -> void:
			background.modulate = DISABLE_COLOR
			disable_flag = true
			mouse_on = false
	)
	_sprite.texture = symbol
	background.modulate = DEFAULT_COLOR


func _process(_delta: float) -> void:
	if mouse_on and Input.is_action_just_pressed("MovePlayer"):
		background.modulate = MOUSE_CLICK_COLOR
		Signals.simon_button_is_pressed.emit(symbol_id)
		await get_tree().create_timer(0.2).timeout

		if mouse_on:
			background.modulate = MOUSE_ON_COLOR
		else:
			background.modulate = DEFAULT_COLOR


func _on_area_2d_mouse_entered() -> void:
	if disable_flag:
		return
	mouse_on = true
	background.modulate = MOUSE_ON_COLOR


func _on_area_2d_mouse_exited() -> void:
	if disable_flag:
		return
	mouse_on = false
	background.modulate = DEFAULT_COLOR
