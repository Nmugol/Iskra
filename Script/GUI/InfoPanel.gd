@tool
extends Control
class_name InfoPanel

@onready var panel: NinePatchRect = $NinePatchRect
@onready var info_text: RichTextLabel = $NinePatchRect/MarginContainer/RichTextLabel

@export_category("Panel size")
@export_range(55, 1000, 5)
var width: float = 300.0:
	set(value):
		width = value
		if panel != null:
			panel.size.x = value
@export_range(55, 1000, 5)
var height: float = 150.0:
	set(value):
		height = value
		if panel != null:
			panel.size.y = value

@export_category("Text")
@export var text_to_display: String = "Info text":
	set(value):
		text_to_display = value
		if info_text != null:
			info_text.text = text_to_display

@export_category("Visibility")
@export var is_visible_flag: bool = false:
	set(value):
		is_visible_flag = value
		if is_inside_tree():  # Sprawdź czy obiekt jest już w scenie
			if is_visible_flag:
				show()
			else:
				hide()

@export var active_on_stages: Array[int] = []

func _ready() -> void:
	# Ustaw początkowe wartości po załadowaniu węzłów
	if panel != null:
		panel.size = Vector2(width, height)
	if info_text != null:
		info_text.text = text_to_display
	
	# Ustaw początkową widoczność
	if is_visible_flag and active_on_stages.has(State.state_number):
		show()
	else:
		hide()
	
	# Połącz sygnały
	Signals.show_map.connect(func (): hide())
	Signals.hide_map.connect(func (): 
		if is_visible_flag and active_on_stages.has(State.state_number): 
			show()
	)

	Signals.show_equipment.connect(func (): hide())
	Signals.hide_equipment.connect(func (): 
		if is_visible_flag and active_on_stages.has(State.state_number): 
			show()
	)
