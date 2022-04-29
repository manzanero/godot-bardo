extends Spatial


var chunk_scene = preload("res://scenes/chunk.tscn")
var wall_cell_preset = preload("res://cells/wall.tres")
var empty_cell_preset = preload("res://cells/empty.tres")

var origin: Vector3
var size: Vector3

var chunks: Dictionary
var cells: Dictionary

var view: PoolVector3Array

func _init():
	chunks = {}
	cells = {}

	view = PoolVector3Array([])


func get_cell(position: Vector3) -> Cell:
	return cells.get(position)


func load_from_donjon(map_text):
	var parsed_text = JSON.parse(map_text)
	if parsed_text.error != OK:
		print("Error parsing Donjon map")
		return 1

	var map_data = parsed_text.result
	name = map_data["settings"]["name"]

	var cells_data = map_data["cells"]
	var map_len_x = 2 * cells_data[0].size()
	var map_len_y = 3
	var map_len_z = 2 * cells_data.size()
	var chunk_len_x = map_len_x / 16 + 1
	var chunk_len_y = map_len_y
	var chunk_len_z = map_len_z / 16 + 1

	origin = Vector3.ZERO
	size = Vector3(chunk_len_x * 16, chunk_len_y, chunk_len_z * 16)
	$MRPAS.new(origin, size)

	for chunk_x in range(chunk_len_x):
		for chunk_y in range(chunk_len_y):
			for chunk_z in range(chunk_len_z):
				var chunk = chunk_scene.instance().new(self, Vector3(chunk_x * 16, chunk_y, chunk_z * 16))
				$Chunks.add_child(chunk)

	for x in range(map_len_x):
		for y in range(map_len_y):
			for z in range(map_len_z):
				var cell: Cell = get_cell(Vector3(x, y, z))
				var cell_code = cells_data[z / 2][x / 2]
				var cell_is_wall = cell_code in [0, 16]
				var state = CellState.new()
				match y:
					0:
						state.preset = wall_cell_preset
#					1:
#						state.preset = empty_cell_preset
					1, 2:
						if cell_is_wall:
							state.preset = wall_cell_preset
							state.uvs.up = Vector2(0, 2)
						else:
							state.preset = empty_cell_preset

				$MRPAS.set_transparent(Vector3(x, y, z), state.tranparent)
				cell.state = state
				cell.status = Cell.Status.EXPLORED

	return self


#func _process(delta):
#	pass


var x = Vector3(11, 1, 12)
var cube = MeshInstance.new()

func _input(event):

	var update = false

	if event is InputEventKey and event.scancode == KEY_W and event.is_pressed():
		x += Vector3.FORWARD
		cube.transform.origin = x
		update = true
	if event is InputEventKey and event.scancode == KEY_S and event.is_pressed():
		x += Vector3.BACK
		cube.transform.origin = x
		update = true
	if event is InputEventKey and event.scancode == KEY_A and event.is_pressed():
		x += Vector3.LEFT
		cube.transform.origin = x
		update = true
	if event is InputEventKey and event.scancode == KEY_D and event.is_pressed():
		x += Vector3.RIGHT
		cube.transform.origin = x
		update = true

	if event is InputEventKey and event.scancode == KEY_K and event.is_pressed():
		cube.free()
		cube = MeshInstance.new()
		cube.mesh = CubeMesh.new()
		cube.transform.origin = x
		add_child(cube)
		update = true

	if update:
		var time_start = OS.get_ticks_msec()

		var fov = $MRPAS.field_of_view(x)

		print("Elapsed1: ", OS.get_ticks_msec() - time_start)

		for p in view:
			var cell: Cell = get_cell(p)
			cell.status = Cell.Status.EXPLORED
			cell.chunk.dirty = true

		var new_view = PoolVector3Array()
		new_view.append_array(fov)
		for p in fov:
			var cell: Cell = get_cell(p)
			cell.status = Cell.Status.REVEALED
			cell.chunk.dirty = true
			while cell.real_state.tranparent:
				var p_down = cell.position + Vector3.DOWN
				new_view.append(p_down)
				cell = get_cell(p_down)
				cell.status = Cell.Status.REVEALED
				cell.chunk.dirty = true

		view = new_view

		print("Elapsed2: ", OS.get_ticks_msec() - time_start)
