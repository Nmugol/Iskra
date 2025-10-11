extends Node2D

@export var symbol: CompressedTexture2D
@export var symbol_id: int

@onready var _sprite = $Symbol

var mouse_on:bool = false


func _ready() -> void:
    _sprite.texture = symbol

func _process(_delta: float) -> void:
    if mouse_on and Input.is_action_just_pressed("MovePlayer"):
        Signals.simon_button_is_pressed.emit(symbol_id)

func _on_area_2d_mouse_entered() -> void:
    mouse_on = true

func _on_area_2d_mouse_exited() -> void:
    mouse_on = false
