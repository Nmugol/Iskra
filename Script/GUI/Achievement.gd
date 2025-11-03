extends Control

@export_category("Icons")
@export var allBookIcons: CompressedTexture2D
@export var allPosterIcons: CompressedTexture2D
@export var textureRack: TextureRect

@export_category("label")
@export var label: Label


func _ready() -> void:
	Signals.pick_up_all_book.connect(
		func() -> void:
			show_achievement("All books", allBookIcons)
	)
	Signals.pick_up_all_posters.connect(
		func() -> void:
			show_achievement("All posters", allPosterIcons)
	)


func show_achievement(text: String, icon: CompressedTexture2D) -> void:
	label.text = text
	textureRack.texture = icon
	show()
	await get_tree().create_timer(5).timeout
	hide()
