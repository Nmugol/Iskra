extends Control

@onready var ItemBox: VBoxContainer

func _ready() -> void:
	Signals.show_equipment.connect(ShowEquipment)
	Signals.load_equiment.connect(CreateItem)
	CreateItem()

func CreateItem() -> void:
	
	#Remove items
	var children = ItemBox.get_children()
	for c in children:
		c.free()
	
	#Load items
	for item: Item in Save.Equipment:
		
		var item_button: Button
		var icon: CompressedTexture2D
		icon.load_path = item.small_sprite_path
		item_button.icon = icon
		item_button.icon_alignment = 1
		item_button.expand_icon = true
		item_button.pressed.connect(self.SelectItem.bind(item))
		
		ItemBox.add_child(item_button)

func SelectItem(item: Item) -> void:
	pass

func ShowEquipment() -> void:
	CreateItem()
	show()

func _on_clouse_pressed() -> void:
	hide()
