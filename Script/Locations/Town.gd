extends Node2D

func _ready() -> void:
	Signals.change_info_panel_visibility.emit(true)
