class_name item extends Node

var item_name: String =""
var contains_items: Array[String] = []
var is_finished: bool = true
var small_sprite: String = ""
var full_sprite: String = ""

func _init(itemName: String, containsItems: Array[String], isFinished: bool, smallSprite: String, fullSprite: String) -> void:
	item_name = itemName
	contains_items = containsItems
	is_finished = isFinished
	small_sprite = smallSprite
	full_sprite = fullSprite
