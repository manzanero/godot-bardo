class_name CellState


var empty: bool = true
var walkable: bool
var tranparent: bool
var uvs: Dictionary
var properties: Dictionary

func _init():
	uvs = {
		"up": Vector2.ZERO,
		"forward": Vector2.ZERO,
		"back": Vector2.ZERO,
		"left": Vector2.ZERO,
		"right": Vector2.ZERO,
		"down": Vector2.ZERO,
	}
	properties = {}
