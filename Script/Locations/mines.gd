extends Node2D

func _ready() -> void:
	Signals.emit_signal("disabe_loadin_screen")


func _on_texture_button_pressed() -> void:
	print("press")
