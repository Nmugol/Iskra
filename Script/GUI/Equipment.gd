extends Control

@onready var ItemBox: VBoxContainer = %ItemBox
@onready var LoolAtItemTexture: TextureRect = %LoolAtItemTexture
@export var UseButton: Button
@export var DisassembleButton: Button
@export var AssembleButton: Button

func _ready() -> void:
	Signals.show_equipment.connect(ShowEquipment)
	Signals.load_equiment.connect(CreateItem)
	Signals.look_at_item.connect(LookAtItem)
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
		
		var item_button: Button = Button.new()
		item_button.icon = load(item.small_sprite_path)
		item_button.custom_minimum_size = Vector2(50,50)
		item_button.texture_filter = 1
		item_button.icon_alignment = 1
		item_button.expand_icon = true
		item_button.pressed.connect(self.LookAtItem.bind(item))
		
		ItemBox.add_child(item_button)

func LookAtItem(item: Item) -> void:
	State.ActiveItem = item
	LoolAtItemTexture.texture = load(item.full_sprite_path)
	
	UseButton.show()
	if not State.ActiveItem.is_finished: DisassembleButton.show()
	else: DisassembleButton.hide()
	AssembleButton.show()

func ShowEquipment() -> void:
	State.IsRun = false
	CreateItem()
	show()

func _on_clouse_pressed() -> void:
	State.IsRun = true
	hide()

func _on_use_pressed() -> void:
	State.SelectedItem = State.ActiveItem
	State.ActiveItem = null

func _on_disassemble_pressed() -> void:
	State.ActiveItem.Disassemble()

func _on_assemble_pressed() -> void:
	State.ActiveItem.Assemble(State.SelectedItem)
