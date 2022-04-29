class_name CellPreset
extends Resource

export (bool) var empty = true
export (bool) var walkable
export (bool) var tranparent
export (Dictionary) var uvs = {
	'up': [Vector2.ZERO],
	'forward': [Vector2.ZERO],
	'back': [Vector2.ZERO],
	'left': [Vector2.ZERO],
	'right': [Vector2.ZERO],
	'down': [Vector2.ZERO],
}
export (Dictionary) var properties


func _init(p_empty = false, p_walkable = false, p_tranparent = false, p_uvs = {}, p_properties = {}):
	empty = p_empty
	walkable = p_walkable
	tranparent = p_tranparent
	uvs = p_uvs
	properties = p_properties
