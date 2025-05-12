extends Node2D

func _process(_delta: float) -> void:
	if not State.LevelIsLoad: return
	match State.StateNumber:
		0:
			match State.StatePhase:
				0: 
					StartDialog();
					State.StatePhase = 1

func StartDialog() -> void:
	Signals.show_dialog.emit()
	Signals.peopel_message.emit("Peter", 
	"
	Hey, Daniel! You're late again.
	I wonder if we'll ever manage to be on time?
	")
	
	Signals.player_message.emit("Daniel",
	"
	Don't even get me started. On the way here, I got stopped for a check.
	They thought I was carrying contraband.
	And you know how long their personal searches take.
	")
	
	Signals.peopel_message.emit("Peter", 
	"
	The guards are especially active today and aren't letting anyone off easy.
	This morning they searched me too, and now I'm super stressed.
	You know I don't want any trouble with the authorities.
	")
	
	Signals.player_message.emit("Daniel",
	"
	[i]I know you don't want any trouble, and you want to do everything you can to 
	increase your chances of transferring camps.[/i]
		
	But did you hear?
	The resistance gave them a hard time again.
	They scattered posters around the camp calling for a rebellion.
	And apparently, they also stole some of the guards' uniforms.
	")
	
	Signals.peopel_message.emit("Guard7",
	"
	[b]Daniel and Peter, you're coming with us.[/b]
	One of the loaded wagons derailed and is blocking the loading of the others.
	You have been chosen to help clear the tracks.
	")
	
	Signals.peopel_message.emit("Peter", 
	"
	[shake rate=15.0 level=2 connecter=1]Whaaa...? Whyyy usss?[/shake]
	")
	
	Signals.peopel_message.emit("Guard8",
	"
	Your Sparks will come in handy for removing the wagon.
	[b]Don't waste our time[/b] and move it.
	")
	
	Signals.player_message.emit("Daniel",
	"
	[b]Alright, we're coming.[/b]
		
	[font_size=18]Peter, calm down and don't panic.[/font_size]
	")
