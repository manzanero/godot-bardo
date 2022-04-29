class_name CellState

var preset: CellPreset setget set_preset

var empty: bool
var walkable: bool
var tranparent: bool

var uvs: Dictionary
var properties: Dictionary


func set_preset(value: CellPreset):
	preset = value

	empty = value.empty
	walkable = value.walkable
	tranparent = value.tranparent
	uvs = {
		'up': value.uvs['up'][0],
		'forward': value.uvs['forward'][0],
		'back': value.uvs['back'][0],
		'left': value.uvs['left'][0],
		'right': value.uvs['right'][0],
		'down': value.uvs['down'][0],
	}
	properties = value.properties.duplicate()


func _init(_preset = null):
	uvs = {}
	properties = {}

	if _preset:
		set_preset(_preset)

