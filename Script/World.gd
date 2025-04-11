extends Node2D

@export var LevelLocation: Node
@onready var Dialog: Control = %Dialog
@onready var Equipment: Control = %Equipment
@onready var Map: Control = %Map
@onready var Transition: AnimationPlayer = %Transition
@onready var SettingsInGame: Control = %Setting

func _ready()->void:
	Signals.show_dialog.connect(ShowDialog)
	Signals.hide_dialog.connect(HideDialog)
	
	Signals.show_equipment.connect(ShowEquipment)
	Signals.hide_equipment.connect(HideEquipment)
	
	Signals.show_map.connect(ShowMap)
	Signals.hide_map.connect(HideMap)
	
	Signals.change_scene.connect(LoadLevel)
	Signals.disabe_loadin_screen.connect(DisabeLoadinScreen)
	Signals.enable_loadin_screen.connect(EnableLoadinScreen)
	
	Signals.show_settin_in_game.connect(ShowSettinIngame)
	Signals.hide_settin_in_game.connect(HideSettinIngame)
	
	State.IsRun = true
	
	LoadLevel()

func ShowSettinIngame() -> void:
	HideDialog()
	HideEquipment()
	HideMap()
	SettingsInGame.show()

func HideSettinIngame() -> void:
	SettingsInGame.hide()
	Signals.show_ui.emit()

func LoadLevel() -> void:
	# Usunięcei cześniejszych załdowanych scen
	var loadLevels = LevelLocation.get_children()
	for l in loadLevels:
		l.free()
	
	# Załadowanie lewelu
	var levelnode = load(Save.CurrentScenePath).instantiate()
	LevelLocation.add_child(levelnode)
	
	DisabeLoadinScreen()

func SaveLevel() -> void:
	Save.CurrentScenePath = LevelLocation.get_child(0).get_path()

func ShowDialog():
	State.IsRun = false
	Dialog.show()
	HideEquipment()
	HideMap()
	HideSettinIngame()

func HideDialog():
	State.IsRun = true
	Dialog.hide()

func ShowEquipment() -> void:
	State.IsRun = false
	Equipment.show()
	HideDialog()
	HideMap()
	HideSettinIngame()

func HideEquipment() -> void:
	State.IsRun = true
	Equipment.hide()

func ShowMap() -> void:
	State.IsRun = false
	Map.show()
	HideDialog()
	HideEquipment()
	HideSettinIngame()

func HideMap() -> void:
	State.IsRun = true
	Map.hide()

func DisabeLoadinScreen() -> void:
	Transition.play("fade_in")
	await Transition.animation_finished
	
	HideDialog()
	HideEquipment()
	HideMap()
	HideSettinIngame()
	Signals.show_ui.emit()

func EnableLoadinScreen() -> void:
	State.IsRun = true
	Transition.play("fade_out")
	await Transition.animation_finished
	
