class_name Map
extends Spatial

var min_x: int
var min_y: int
var min_z: int
var max_x: int
var max_y: int
var max_z: int

var chunks: Dictionary
var cells: Dictionary
var view: Dictionary


func _init():
	chunks = {}
	cells = {}
	view = {}


func get_cell(position: Vector3) -> Cell:
	return cells.get(position)


func get_relative_cell(cell, offset: Vector3) -> Cell:
	return get_cell(cell.position + offset)


func get_relative_cell_state(cell, offset: Vector3) -> CellState:
	var relative_cell = get_relative_cell(cell, offset)
	return relative_cell.state if relative_cell else null


var x = Vector3(11, 1, 12)
var cube = MeshInstance.new()

func _input(event):
	if event is InputEventKey and event.scancode == KEY_W:
		x += Vector3.FORWARD
		cube.transform.origin = x
	if event is InputEventKey and event.scancode == KEY_S:
		x += Vector3.BACK
		cube.transform.origin = x
	if event is InputEventKey and event.scancode == KEY_A:
		x += Vector3.LEFT
		cube.transform.origin = x
	if event is InputEventKey and event.scancode == KEY_D:
		x += Vector3.RIGHT
		cube.transform.origin = x

	if event is InputEventKey and event.scancode == KEY_K and not event.echo:
		cube.free()
		cube = MeshInstance.new()
		cube.mesh = CubeMesh.new()
		add_child(cube)

	if event is InputEventKey:
		var fov = get_node("../../MapMRPAS").field_of_view(x)

		for p in fov:
			var cell = cells[p]
			cell.status = Cell.Status.REVEALED
			cell.chunk.dirty = true
			cell = cells[p + Vector3.DOWN]
			cell.status = Cell.Status.REVEALED
			cell.chunk.dirty = true
#			var cell = cells[p + Vector3.DOWN]
#			if not cell.status == Cell.Status.REVEALED:
#				cell.status = Cell.Status.REVEALED
#				cell.chunk.dirty = true
