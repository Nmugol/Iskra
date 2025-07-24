extends Node2D

@export var LevelLocation: Node

@onready var Dialog: Control = %Dialog
@onready var Equipment: Control = %Equipment
@onready var Map: Control = %Map
@onready var Transition: AnimationPlayer = %Transition
@onready var SettingsInGame: Control = %Setting
@onready var ContronButton: Control = %UI

func _ready() -> void:
	Transition.play("loading")
	await Transition.animation_finished
	
	_connect_signals()
	LoadLevel()

func _connect_signals() -> void:
	Signals.show_ui.connect(func():
		SettingsInGame.show()
		)
	
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
	
func LoadLevel() -> void:
	State.IsRun = false
	# Usunięcei cześniejszych załdowanych scen
	for l in LevelLocation.get_children():
		l.queue_free()
	
	# Załadowanie lewelu
	var levelnode = load(Save.CurrentScenePath).instantiate()
	LevelLocation.add_child(levelnode)
	DisabeLoadinScreen()
	Signals.save_game.emit()
	Signals.save_to_file.emit()

func SaveLevel() -> void:
	Save.CurrentScenePath = LevelLocation.get_child(0).get_path()

func ShowDialog() -> void:
	Signals.reset_coursor.emit()
	State.IsRun = false
	Dialog.show()
	HideEquipment()
	HideSettinIngame()
	HideMap()
	ContronButton.hide()

func HideDialog() -> void:
	State.IsRun = true
	Dialog.hide()
	ContronButton.show()
	SettingsInGame.show()

func ShowEquipment() -> void:
	State.IsRun = false
	Signals.reset_coursor.emit()
	
	Equipment.show()
	HideDialog()
	HideMap()
	HideSettinIngame()

func HideEquipment() -> void:
	State.IsRun = true
	Equipment.hide()

func ShowMap() -> void:
	Signals.reset_coursor.emit()
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
	HideDialog()
	HideEquipment()
	HideMap()
	Signals.show_ui.emit()
	await Transition.animation_finished
	await get_tree().create_timer(0.2).timeout
	State.LevelIsLoad = true
	
	
	

func EnableLoadinScreen() -> void:
	
	Transition.play("fade_out")
	await Transition.animation_finished

func ShowSettinIngame() -> void:
	
	HideDialog()
	HideEquipment()
	HideMap()
	SettingsInGame.show()

func HideSettinIngame() -> void:
	SettingsInGame.hide()
	
