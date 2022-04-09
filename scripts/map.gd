class_name Map extends Spatial


var min_x
var max_x
var min_y
var max_y
var min_z
var max_z

var chunks: Dictionary


func get_len_x(): return max_x - min_x
func get_len_y(): return max_x - min_x
func get_len_z(): return max_z - min_z


func _init():
	chunks = {}


func get_cell(x: int, y: int, z: int):
	var chunk_x
	var chunk_z
	var chunk_cell_x
	var chunk_cell_z

	if x >= 0:
		chunk_x = x / 16
		chunk_cell_x = x % 16
	else:
		chunk_x = x / 16 - 1
		chunk_cell_x = 16 - x % 16

	if z >= 0:
		chunk_z = z / 16
		chunk_cell_z = z % 16
	else:
		chunk_z = z / 16 - 1
		chunk_cell_z = 16 - z % 16

	var chunk = chunks.get(Vector3(chunk_x, y, chunk_z))
	return chunk.cells[chunk_cell_z][chunk_cell_x] if chunk else null


func get_relative_cell(cell: Cell, x: int, y: int, z: int) -> Cell:
	return get_cell(cell.map_x + x, cell.map_y + y, cell.map_z + z)


func get_relative_cell_state(cell: Cell, x: int, y: int, z: int) -> Cell.State:
	var relative_cell = get_relative_cell(cell, x, y, z)
	return relative_cell.state if relative_cell else null
