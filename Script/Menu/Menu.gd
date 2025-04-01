extends Control

var SettingsScene = "res://Scenes/Menu/Settings.tscn"
var PlayScene = "res://Scenes/World.tscn"

@onready var Transition: AnimationPlayer = $Transition2
@export var fade: ColorRect

func _ready() -> void:
	fade.hide()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file(SettingsScene)

func _on_play_button_down() -> void:
	Transition.play("fade_out")
	await Transition.animation_finished
	get_tree().change_scene_to_file(PlayScene)
