extends Control

@onready var item_box: VBoxContainer = %ItemBox
@onready var look_at_item_texture: TextureRect = %LookAtItemTexture
@export var use_button: Button
@export var disassemble_button: Button
@export var assemble_button: Button

func _ready() -> void:
	Signals.show_equipment.connect(show_equipment)
	Signals.load_equipment.connect(create_item)
	Signals.look_at_item.connect(look_at_item)
	Signals.reset_look_at_item.connect(func () -> void: look_at_item_texture.texture = null)
	set_up()
	create_item()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Close") and visible:
		_on_close_pressed()


func set_up() -> void:
	use_button.hide()
	disassemble_button.hide()
	assemble_button.hide()


func create_item() -> void:
	
	#Remove items
	var children = item_box.get_children()
	for c in children:
		c.free()
	
	#Load items
	for item: Item in Save.equipment:
		
		var item_button: Button = Button.new()
		item_button.flat = true
		item_button.icon = load(item.small_sprite_path)
		item_button.custom_minimum_size = Vector2(50,100)
		item_button.texture_filter = TEXTURE_FILTER_NEAREST
		item_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_button.expand_icon = true
		item_button.pressed.connect(self.look_at_item.bind(item))
		
		item_box.add_child(item_button)


func look_at_item(item: Item) -> void:
	State.active_item = item
	look_at_item_texture.texture = load(item.full_sprite_path)
	
	use_button.show()
	if not State.active_item.is_finished: disassemble_button.show()
	else: disassemble_button.hide()
	assemble_button.show()


func show_equipment() -> void:
	State.is_running = false
	create_item()
	show()


func _on_close_pressed() -> void:
	Signals.hide_equipment.emit()


func _on_disassemble_pressed() -> void:
	State.active_item.disassemble()


func _on_assemble_pressed() -> void:
	State.active_item.assemble(State.selected_item)


func _on_use_pressed() -> void:
	State.selected_item = State.active_item
