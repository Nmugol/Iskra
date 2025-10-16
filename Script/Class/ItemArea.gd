@tool
extends Area2D
class_name ItemArea

@export_category("Item")
@export var area_name: State.Cursors_above = State.Cursors_above.NONE
@export var active_on: Array[int] = []

@export_category("Detection")
@export_range(0, 30, 0.2) var item_area_size: float = 8:
	set(value):
		item_area_size = value
		_update_area()
	get:
		return item_area_size


@export_range(10, 40, 0.2) var distance_to_item: float = 10:
	set(value):
		distance_to_item = value
		_update_area()
	get:
		return distance_to_item

@onready var light: PointLight2D = $PointLight2D
@onready var item_area: CollisionShape2D = $CollisionShape2D
@onready var distance_area: CollisionShape2D = $Distance/CollisionShape2D

var player_in_item_area: bool = false
var mouse_on: bool = false
var message_sent: bool = false

var is_not_item_messages: Array[String] = [
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

var is_something_here_message: Array[String] = [
	"This might come in handy later!",
	"This could be useful for something.",
	"This can probably be used for crafting.",
	"This looks like it might be important.",
	"I should keep this - it might be useful.",
	"This could help me on my journey.",
	"I might need this for a quest.",
	"This seems valuable - better hold onto it.",
	"I can definitely make use of this.",
	"This item could be crucial later on."
]

var out_of_range_messages: Array[String] = [
	"I can't reach that from here.",
	"It's too far away.",
	"I need to get closer to that.",
	"That's out of my reach.",
	"I should move closer first.",
	"I'm not close enough to interact with that.",
	"I need to be nearer to examine that.",
	"That's beyond my reach.",
	"I can't get to that from this distance.",
	"I should approach that first."
]

func _ready() -> void:
	self.mouse_entered.connect(_pick_up)
	self.mouse_exited.connect(_on_mouse_exited)
	
	Signals.remove_items_from_scene.connect(remove_form_scene)
	Signals.remove_all_items_from_scene.connect(func(): if State.state_number not in active_on: self.queue_free())

	if item_area and item_area.shape: item_area.shape = item_area.shape.duplicate()
	if distance_area and distance_area.shape: distance_area.shape = distance_area.shape.duplicate()
	
	_update_area()

	if State.state_number not in active_on: self.queue_free()

func _update_area() -> void:
	if not item_area or not distance_area: return
	
	if item_area.shape: item_area.shape.radius = item_area_size
	if distance_area.shape: distance_area.shape.radius = distance_to_item

func remove_form_scene(item: State.Cursors_above) -> void:
	if area_name == item: 
		self.queue_free()

func _pick_up() -> void:
	Signals.set_cursor.emit(State.Cursors.PICKUP)
	mouse_on = true
	message_sent = false
	light.enabled = true
	
	Signals.mouse_above_item.emit(area_name)

func _on_mouse_exited() -> void:
	Signals.mouse_off_item.emit()
	Signals.reset_cursor.emit()
	mouse_on = false
	light.enabled = false

func _process(_delta: float) -> void:
	if not mouse_on:
		return

	if Input.is_action_just_pressed("MovePlayer"):
		var temp_state_number = State.state_number
		var temp_state_phase = State.state_phase
		if not player_in_item_area:
			Signals.show_dialog.emit()
			Signals.player_message.emit("Daniel", out_of_range_messages.pick_random(), false)
			message_sent = true
		elif not message_sent:
			State.player_in_item_area = true
			if area_name == State.Cursors_above.NONE:
				Signals.mouse_above_item.emit(area_name)
				Signals.show_dialog.emit()
				Signals.player_message.emit("Daniel", is_not_item_messages.pick_random(), false)
				self.queue_free()
			else:
				Signals.mouse_above_item.emit(area_name)
				Signals.show_dialog.emit()
				Signals.player_message.emit("Daniel", is_something_here_message.pick_random(), false)
			
			State.state_number = temp_state_number
			State.state_phase = temp_state_phase
			message_sent = true
func _on_distance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_item_area = true
		State.player_in_item_area = true

func _on_distance_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_item_area = false
		State.player_in_item_area = false
