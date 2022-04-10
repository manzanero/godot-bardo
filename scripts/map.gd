class_name Map
extends Spatial


var from: Vector3
var to: Vector3


var chunks: Dictionary
var cells: Dictionary


func get_len_x(): return to.x - from.x
func get_len_y(): return to.y - from.y
func get_len_z(): return to.z - from.z


func _init():
	chunks = {}
	cells = {}


func init_cells(init_from: Vector3, init_to: Vector3):
	for x in range(init_from.x, init_to.x):
		for y in range(init_from.y, init_to.y):
			for z in range(init_from.z, init_to.z):
				var cell = Cell.new()
				cell.position = Vector3(x, y, z)
				cells[cell.position] = cell


func get_cell(position: Vector3):
	return cells.get(position)


func get_relative_cell(cell, offset: Vector3):
	return get_cell(cell.position + offset)


func get_relative_cell_state(cell, offset: Vector3):
	var relative_cell = get_relative_cell(cell, offset)
	return relative_cell.state if relative_cell else null
