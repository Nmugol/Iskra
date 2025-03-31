extends Node2D

@export var LevelLocation: Node
@onready var Dialog: Control = %Dialog
@onready var Equipment: Control = %Equipment
@onready var Map: Control = %Map

func _ready()->void:
	Signals.show_dialog.connect(ShowDialog)
	Signals.hide_dialog.connect(HideDialog)
	
	Signals.show_equipment.connect(ShowEquipment)
	Signals.hide_equipment.connect(HideEquipment)
	
	Signals.show_map.connect(ShowMap)
	Signals.hide_map.connect(HideMap)
	
	Signals.change_scene.connect(LoadLevel)
	Signals.disabe_loadin_screen.connect(DisabeLoadinScreen)
	
	State.IsRun = true
	LoadLevel()

func LoadLevel() -> void:
	# Usunięcei cześniejszych załdowanych scen
	var loadLevels = LevelLocation.get_children()
	for l in loadLevels:
		l.free()
	
	# Załadowanie lewelu
	var levelnode = load(Save.CurrentScenePath).instantiate()
	LevelLocation.add_child(levelnode)

func SaveLevel() -> void:
	Save.CurrentScenePath = LevelLocation.get_child(0).get_path()

func ShowDialog():
	Settings.IsRun = false
	Dialog.show()

func HideDialog():
	Settings.IsRun = true
	Dialog.hide()

func ShowEquipment() -> void:
	State.IsRun = false
	Equipment.show()

func HideEquipment() -> void:
	State.IsRun = true
	Equipment.hide()

func ShowMap() -> void:
	State.IsRun = false
	Map.show()

func HideMap() -> void:
	State.IsRun = true
	Map.hide()

func DisabeLoadinScreen() -> void:
	pass
