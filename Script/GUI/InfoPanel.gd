@tool
extends Control
class_name InfoPanel

@onready var panel: NinePatchRect = $NinePatchRect
@onready var info_text: RichTextLabel = $NinePatchRect/MarginContainer/RichTextLabel

@export_category("Panel size")
@export_range(55, 1000, 5)
var width: float = 300.0:
    set(value):
        panel.size.x = value
        width = value
@export_range(55, 1000, 5)
var height: float = 150.0:
    set(value):
        panel.size.y = value
        height = value

@export_category("Text")
@export var text: String = "Info text":
    set(value):
        text = value
        info_text.text = value

@export_category("Visibility")
@export var is_visible_flag: bool = false:
    set(value):
        is_visible_flag = value
        if is_visible_flag:
            show()
        else:
            hide()

@export var active_on_stages: Array[int] = []

func _ready() -> void:
    info_text.bbcode_enabled = true

    panel.size = Vector2(width, height)
    info_text.text = text

    Signals.show_map.connect(func (): hide())
    Signals.hide_map.connect(func (): if is_visible_flag and active_on_stages.has(State.state_number): show())

    Signals.show_equipment.connect(func (): hide())
    Signals.hide_equipment.connect(func (): if is_visible_flag and active_on_stages.has(State.state_number): show())

