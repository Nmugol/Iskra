extends Node2D

func _ready():
    var index = 0
    for s: Stone in get_children():
        s.id = index
        index += 1