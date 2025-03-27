extends Control

@onready var ItemBox: VBoxContainer = %ItemBox
@onready var LoolAtItemTexture: TextureRect = %LoolAtItemTexture
@export var UseButton: Button
@export var DisassembleButton: Button
@export var AssembleButton: Button

func _ready() -> void:
	Signals.show_equipment.connect(ShowEquipment)
	Signals.load_equiment.connect(CreateItem)
	SetUp()
	CreateItem()

func SetUp() -> void:
	UseButton.hide()
	DisassembleButton.hide()
	AssembleButton.hide()

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
		item_button.pressed.connect(self.LoolAtItem.bind(item))
		
		ItemBox.add_child(item_button)

func LoolAtItem(item: Item) -> void:
	State.ActiveItem = item
	var texture: CompressedTexture2D
	texture.load_path = item.full_sprite_path
	LoolAtItemTexture.texture = texture
	
	UseButton.show()
	if not item.is_finished: DisassembleButton.show()
	AssembleButton.show()

func ShowEquipment() -> void:
	CreateItem()
	show()

func _on_clouse_pressed() -> void:
	hide()

func _on_use_pressed() -> void:
	State.SelectedItem = State.ActiveItem
	State.ActiveItem = null

func _on_disassemble_pressed() -> void:
	State.ActiveItem.Disassemble()

func _on_assemble_pressed() -> void:
	State.ActiveItem.Assemble(State.SelectedItem)
