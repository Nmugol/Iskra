@tool

class_name Stone
extends RigidBody2D

enum StoneSize{
    SMALL,
    LARGE_VERTICAL,
    LARGE_HORIZONTAL,
    BIG
}

var sprite_size_small: CompressedTexture2D = preload("res://Assets/MiniGame/StoneMiniGame/stone_small.png")
var sprite_size_large_vertical: CompressedTexture2D = preload("res://Assets/MiniGame/StoneMiniGame/stone_large_vertical.png")
var sprite_size_large_horizontal: CompressedTexture2D = preload("res://Assets/MiniGame/StoneMiniGame/stone_large_horizontal.png")
var sprite_size_big: CompressedTexture2D = preload("res://Assets/MiniGame/StoneMiniGame/stone_big.png")

@onready var sprite: Sprite2D = $Sprite2D

@export_category("Sprite")
@export var _stoneSize: StoneSize = StoneSize.SMALL:
    set(value):
        _stoneSize = value
        match StoneSize:
            StoneSize.SMALL:
                sprite.texture = sprite_size_small
            StoneSize.LARGE_VERTICAL:
                sprite.texture = sprite_size_large_vertical
            StoneSize.LARGE_HORIZONTAL:
                sprite.texture = sprite_size_large_horizontal
            StoneSize.BIG:
                sprite.texture = sprite_size_big
    get:
        return StoneSize
    