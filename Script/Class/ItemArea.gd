extends Area2D
class_name ItemArea

@export var area_name: String
@export var active_on: Array[int] = []

@export var is_item: bool = false
@export var mouse_on: bool = false

var messages: Array[String] =[
	"There's nothing here.",
	"I can't make anything out of this.",
	"This is a dead end.",
	"There's nothing to see.",
	"I've got nothing to work with.",
	"I can't do anything with this.",
	"This is a lost cause.",
	"There's no point in trying.",
	"I'm getting nowhere with this.",
	"I'm coming up empty."
]
func _ready() -> void:
	
	self.mouse_entered.connect(_pick_up)
	
	self.mouse_exited.connect(func():
		Signals.mouse_off_item.emit()
		Signals.reset_cursor.emit()
		
		if not is_item: mouse_on = false
		)
	
	Signals.remove_items_from_scene.connect(remove_form_scene)

	remove_form_scene()
	
func _pick_up() -> void:
	Signals.set_cursor.emit(State.Cursors.PICKUP)

	if is_item: 
		Signals.mouse_above_item.emit(area_name, self.global_position)
		self.queue_free()
	else: 
		mouse_on = true

func remove_form_scene():
	if State.state_number not in active_on: self.queue_free()

func _process(_delta: float) -> void:
	if not is_item and mouse_on and Input.is_action_just_pressed("MovePlayer"):
		State.is_running = false
		Signals.show_dialog.emit()
		Signals.player_message.emit("Daniel", messages[randi_range(0, messages.size()-1)])
		State.state_phase -= 1
		self.queue_free()
