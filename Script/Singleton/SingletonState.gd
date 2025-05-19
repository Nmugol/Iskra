extends Node

var LevelIsLoad: bool = false

var IsRun: bool = true
var IsInArea: bool = false

var PickUpItems: Array[Item] = []

var StateNumber: int = 0
var StatePhase: int = 0

var ActiveItem: Item
var SelectedItem: Item
