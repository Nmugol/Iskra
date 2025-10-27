extends Node

var is_loading: bool = false
var is_running: bool = true

var is_in_area: bool = false

var pick_up_items: Array[Item] = []
var player_in_item_area: bool = false

var state_number: int = 0
var state_phase: int = 0
var day_count: int = 1

var active_item: Item
var selected_item: Item
var can_play_sfx: bool = true

var pick_up_books: Array = []
var pick_up_all_book: bool = false

var pick_up_poster: Array = []
var pick_up_all_poster: bool = false

const MAIN_SCENE = "res://Scenes/World.tscn"

enum Cursors {
	DEFAULT,
	PICKUP,
	USE,
	WALK,
}

enum AudioType {
	Effect,
	Music,
}

enum Cursors_above {
	STEEL_SHEET,
	CRYSTAL_SHARD,
	NONE,
}

enum Locations {
	NONE,
	Shopping_Area,
	Residential_Area,
	Railway_Station,
	Mines,
	Town,
}

enum AchievedType {
	BOOK,
	POSTER,
}
