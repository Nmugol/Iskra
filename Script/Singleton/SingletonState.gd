extends Node

var is_loading: bool = false
var is_running: bool = true

var is_in_area: bool = false

var pick_up_items: Array[Item] = []

var state_number: int = 0
var state_phase: int = 0

var active_item: Item
var selected_item: Item

enum Cursors {
	DEFAULT,
	PICKUP,
	USE,
	WALK
}

enum AudioType {
    Effect,
    Music
}
