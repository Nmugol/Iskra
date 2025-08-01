extends Control

const SETTINGS_SCENE = "res://Scenes/Menu/Settings.tscn"
const PLAY_SCENE = "res://Scenes/World.tscn"

@onready var transition: AnimationPlayer = $Transition2
@export var fade: ColorRect

func _ready() -> void:
	fade.hide()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file(SETTINGS_SCENE)

func _on_play_button_down() -> void:
	transition.play("fade_out")
	await transition.animation_finished
	get_tree().change_scene_to_file(PLAY_SCENE)
