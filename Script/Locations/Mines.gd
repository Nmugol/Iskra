extends Node2D

@onready var guard7: NPC = $Path2D/PathFollow2D/Guard5
@onready var guard8: NPC = $Path2D/PathFollow2D/Guard6

@onready var path: PathFollow2D = $Path2D/PathFollow2D

const  MainScene = "res://Scenes/World.tscn"

var speed_ratio = 0.07    # prędkość w jednostkach ratio na sekundę
var target_ratio = 0.45   # gdzie ma się zatrzymać

var walk: bool = false

var thread: Thread

func  _ready() -> void:
	State.StatePhase = 0
	path.progress_ratio = 0.0
	guard7.update_state("Walk", false)
	guard8.update_state("Walk", false)

func _process(delta: float) -> void:
	if not State.LevelIsLoad: return
	
	if walk:
		path.progress_ratio = move_toward(path.progress_ratio, target_ratio, speed_ratio*delta)
	if abs(path.progress_ratio - target_ratio) < 0.001:
		path.progress_ratio = target_ratio
		walk = false
		
	
	match State.StateNumber:
		0:
			match State.StatePhase:
				0: 
					StartDialog();
				4:
					guard7.update_state("Walk", false)
					guard8.update_state("Walk", false)
					walk = true
				5: 
					path.progress_ratio = target_ratio
					guard7.update_state("Idle", true)
					guard8.update_state("Idle", true)
					$NPCS/Peter.flip_sprite = false
				8:
					guard7.update_state("Walk", true)
					guard8.update_state("Walk", true)
					target_ratio = 1
					walk = true
				
				9:
					State.StateNumber = 1
					State.StatePhase = 0
					Save.PlayerPosition = Vector2(2048,-8)
					Save.CurrentScenePath = "res://Scenes/Locations/RailwayStation/RailwayStation.tscn"
					Signals.enable_loadin_screen.emit()
					get_tree().change_scene_to_file(MainScene)

func StartDialog() -> void:
	
	Signals.show_dialog.emit()
	#1
	Signals.peopel_message.emit("Peter", 
	"
	Hey, Daniel! You're late again.
	I wonder if we'll ever manage to be on time?
	")
	
	#2
	Signals.player_message.emit("Daniel",
	"
	Don't even get me started. On the way here, I got stopped for a check.
	They thought I was carrying contraband.
	And you know how long their personal searches take.
	")
	
	#3
	Signals.peopel_message.emit("Peter", 
	"
	The guards are especially active today and aren't letting anyone off easy.
	This morning they searched me too, and now I'm super stressed.
	You know I don't want any trouble with the authorities.
	")
	
	#4
	Signals.player_message.emit("Daniel",
	"
	[i]I know you don't want any trouble, and you want to do everything you can to 
	increase your chances of transferring camps.[/i]
		
	But did you hear?
	The resistance gave them a hard time again.
	They scattered posters around the camp calling for a rebellion.
	And apparently, they also stole some of the guards' uniforms.
	")
	
	#5
	Signals.peopel_message.emit("Guard7",
	"
	[b]Daniel and Peter, you're coming with us.[/b]
	One of the loaded wagons derailed and is blocking the loading of the others.
	You have been chosen to help clear the tracks.
	")
	
	#6
	Signals.peopel_message.emit("Peter", 
	"
	[shake rate=15.0 level=2 connecter=1]Whaaa...? Whyyy usss?[/shake]
	")
	
	#7
	Signals.peopel_message.emit("Guard8",
	"
	Your Sparks will come in handy for removing the wagon.
	[b]Don't waste our time[/b] and move it.
	")
	
	#8
	Signals.player_message.emit("Daniel",
	"
	[b]Alright, we're coming.[/b]
		
	[font_size=16]Peter, calm down and don't panic.[/font_size]
	")
