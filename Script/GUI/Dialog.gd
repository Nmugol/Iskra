extends Node

@export var Icons: Dictionary[String, CompressedTexture2D]

@onready var peopelPanel: Panel = %PeopelPanel
@onready var peopelIcons: TextureRect = %PeopleIcons
@onready var playerPanel: Panel = %PlayerPanel
@onready var playerIcons: TextureRect = %PlayerIcons
@onready var scroll: ScrollContainer = %ScrollContainer
@onready var Text: RichTextLabel = %Text
@onready var timer: Timer = $Timer
@onready var closeButton: Button = %CloseButton

var displaySpeed: float = 0.1
var queue: Array = []
var is_talking: bool = false
var next: bool = false
var text_is_end: bool = false
var finus_statae: bool = true

var thread: Thread
var mutex: Mutex = Mutex.new()
var should_exit: bool = false

func _ready() -> void:
	Text.bbcode_enabled = true
	finus_statae = true
	Signals.peopel_message.connect(add_people_message)
	Signals.player_message.connect(add_player_message)
	
	thread = Thread.new()
	thread.start(_thread_process)

func add_people_message(icon: String, text: String):
	mutex.lock()
	queue.append([PeopleTalk, icon, text])
	mutex.unlock()

func add_player_message(icon: String, text: String):
	mutex.lock()
	queue.append([PlayerTalk, icon, text])
	mutex.unlock()

func _thread_process():
	while true:
		mutex.lock()
		if should_exit:
			mutex.unlock()
			return
			
		if queue.is_empty() or is_talking:
			mutex.unlock()
			await Engine.get_main_loop().process_frame
			continue
			
		is_talking = true
		var item = queue.pop_front()
		mutex.unlock()
		
		# Przekazujemy obsługę UI do głównego wątku
		call_deferred("_process_item", item)

func _process_item(item: Array):
	var func_ref = item[0]
	var iconName = item[1]
	var textToDisplay = item[2]
	
	func_ref.call(iconName, textToDisplay)
	State.StatePhase += 1
	
	# Oczekiwanie na głównym wątku
	next = false
	while not next:
		await get_tree().process_frame
	
	mutex.lock()
	is_talking = false
	mutex.unlock()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LoadText"):
		displaySpeed = 0.01
	if Input.is_action_just_pressed("NextText") and text_is_end:
		next = true
	if queue.is_empty() and not is_talking:
		closeButton.show()

func PeopleTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	playerPanel.hide()
	closeButton.hide()
	peopelIcons.texture = Icons[iconName]
	peopelPanel.show()
	await LoadinText(textToDisplay)

func PlayerTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	peopelPanel.hide()
	closeButton.hide()
	playerIcons.texture = Icons[iconName]
	playerPanel.show()
	await LoadinText(textToDisplay)

func LoadinText(text: String) -> void:
	text_is_end = false
	displaySpeed = 0.1
	Text.clear()
	Text.bbcode_text = text
	Text.visible_characters = 0
	
	for i in text.length():
		timer.start(displaySpeed)
		Text.visible_characters += 1
		scroll.scroll_vertical = floor(scroll.get_v_scroll_bar().max_value)
		await timer.timeout
		
	text_is_end = true

func _on_close_button_pressed() -> void:
	Signals.hide_dialog.emit()
	State.IsRun = true

func _exit_tree():
	mutex.lock()
	should_exit = true
	mutex.unlock()
	thread.wait_to_finish()
