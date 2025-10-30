extends Node2D

@export var info_panel: InfoPanel

@export_category("NPC-s")
@export var _peter: NPC
@export var _james: NPC
@export var _przemek: NPC

@onready var _player: Player = $Player


func _ready() -> void:
	match State.state_number:
		27:
			match State.state_phase:
				0:
					_peter.show()
					_james.show()
					_przemek.show()
		_:
			_peter.hide()
			_james.hide()
			_przemek.hide()


func _process(_delta: float) -> void:
	if State.is_loading:
		return

	match State.state_number:
		28:
			match State.state_phase:
				0:
					_player.position = Vector2(904, 129)
					_first_dialog()

					var radio: Item = Item.new(
						"Radio",
						[],
						true,
						"res://Sprite/Items/RadioSmal.png",
						"res://Sprite/Items/Radio.png",
						["Battery"],
						"Powered radio",
						"res://Sprite/Items/RadioPowerSmall.png",
						"res://Sprite/Items/RadioPower.png",
						[],
						true,
					)

					var battery: Item = Item.new(
						"Battery",
						[],
						true,
						"res://Sprite/Items/BatterySmall.png",
						"res://Sprite/Items/Battery.png",
						[],
						"",
						"",
						"",
						[],
						true,
					)

					radio.add_to_equipment()
					battery.add_to_equipment()
				25:
					State.state_number = 26
					State.state_phase = 0
					Save.player_position = Vector2(440, -184)
					Save.current_scene_path = 'res://Scenes/Locations/Town/DanielHouse.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)


func _first_dialog() -> void:
	Signals.show_dialog.emit()

	Signals.people_message.emit("Przemek", "Well, I did everything according to plan. I let him go home early, like you said. As he was leaving the mine, I saw him talking to Peter. I bet they'll come together.", true)
	Signals.people_message.emit("James", "Zygmunt said he came to him with the symbols yesterday. So if curiosity got the better of him, he should show up here any minute.", true)
	Signals.people_message.emit("Peter", "This tunnel goes on and on forever. Oh, I think I see the end. Wait, am I hearing the supervisor's voice correctly?", true)
	Signals.player_message.emit("Daniel", "What would he be doing here?", true)
	Signals.people_message.emit("James", "Speak of the devils. Welcome to the resistance.", true)
	Signals.people_message.emit("Peter", "What, what, whaaat? The resistance??? But how...?", true)
	Signals.people_message.emit("Przemek", "Peter, calm down.", true)
	Signals.player_message.emit("Daniel", "Are you kidding me, or what?", true)
	Signals.people_message.emit("James", "Daniel, me and jokes? You know me, you know I'm the more serious brother in the family.", true)
	Signals.people_message.emit("James", "Just listen to me calmly.", true)
	Signals.people_message.emit("James", "Because of my brother's antics, I decided to start a resistance. We're facing an important operation, and we need your help.", true)
	Signals.people_message.emit("James", "Your 'sparks' play a key role in this. With the supervisor's help, we are digging a tunnel towards the walls.", true)
	Signals.people_message.emit("Przemek", "But because of yesterday's gas leak, we're delayed. We have to dig another 50 meters by tomorrow.", true)
	Signals.people_message.emit("James", "In short, we're asking for your help in digging this tunnel and repairing the tools.", true)
	Signals.people_message.emit("Peter", "But... us???", true)
	Signals.player_message.emit("Daniel", "Peter, calm down. What would our help consist of?", true)
	Signals.people_message.emit("James", "Daniel, with your gift, you would be responsible for digging. Meanwhile, Peter would be responsible for quick tool repair.", true)
	Signals.people_message.emit("James", "It's just a question of whether you agree?", true)
	Signals.player_message.emit("Daniel", "On behalf of myself and Peter, I'll say right now: we agree.", true)
	Signals.people_message.emit("Peter", "Daniel, whaaat? What do you mean 'we agree'?", true)
	Signals.player_message.emit("Daniel", "Peter, we finally have a chance to break out of this camp. To do something more than live from morning till night in fear of being arrested for nothing.", true)
	Signals.people_message.emit("James", "I'm glad to hear that. So, I'll see you tomorrow at the mine.", true)
	Signals.people_message.emit("James", "Oh, Daniel, can you help me with one more thing? I'm completely swamped at the workshop and I can't get everything ready by tomorrow.", true)
	Signals.people_message.emit("James", "Can you fix this radio for me? Here's the radio and the batteries. I don't know why I can't power it.", true)
	Signals.player_message.emit("Daniel", "Sure, I'll help.", true)
	Signals.people_message.emit("Przemek", "Alright, it's getting late and my wife is waiting with the anniversary dinner. So, if we can, let's head home.", true)
