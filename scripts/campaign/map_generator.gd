extends Node

var map_scene = preload("res://scenes/map.tscn")
var chunk_scene = preload("res://scenes/chunk.tscn")

onready var campaign = get_node("..")
onready var maps_parent = get_node("../Maps")
onready var maps_mrpas = get_node("../MapMRPAS")


func create_scene_from_donjon(map_text):
	var parsed_text = JSON.parse(map_text)
	if parsed_text.error != OK:
		print("Error parsing Donjon map")
		return 1

	var map_data = parsed_text.result
	var cells_data = map_data["cells"]
	var len_x = 2 * cells_data[0].size()
	var len_z = 2 * cells_data.size()
	var chunk_len_x = len_x / 16 + 1
	var chunk_len_y = 3
	var chunk_len_z = len_z / 16 + 1
	var map_len_x = chunk_len_x * 16
	var map_len_y = chunk_len_y
	var map_len_z = chunk_len_z * 16

	var map = map_scene.instance()
	map.name = map_data["settings"]["name"]
	maps_parent.add_child(map)
	maps_mrpas.init(Vector3.ZERO, Vector3(map_len_x, map_len_y, map_len_z))

	for chunk_x in range(chunk_len_x):
		for chunk_y in range(chunk_len_y):
			for chunk_z in range(chunk_len_z):
				chunk_scene.instance().init(map, Vector3(chunk_x, chunk_y, chunk_z))

	for z in range(map_len_z):
		for x in range(map_len_x):
			var cell: Cell = map.get_cell(Vector3(x, 0, z))

#			cell.status = Cell.Status.REVEALED

			var state = CellState.new()
			state.empty = false
			state.walkable = false
			state.tranparent = false
			state.uvs.up = Vector2(0, 0)
			state.uvs.forward = Vector2(0, 1)
			state.uvs.back = Vector2(0, 1)
			state.uvs.left = Vector2(0, 1)
			state.uvs.right = Vector2(0, 1)
			state.uvs.down = Vector2(0, 2)

			cell.state = state

	for y in [1, 2]:
		for z in range(map_len_z):
			for x in range(map_len_x):
				var cell: Cell = map.get_cell(Vector3(x, y, z))

				var map_x = clamp(x, 0, len_x - 1)
				var map_z = clamp(z, 0, len_z - 1)
				var cell_code = cells_data[map_z / 2][map_x / 2]
				var cell_is_wall = cell_code in [0, 16]

#				cell.status = Cell.Status.REVEALED

				var state = CellState.new()
				if cell_is_wall:
					state.empty = false
					state.uvs.up = Vector2(0, 2)
					state.uvs.forward = Vector2(0, 1)
					state.uvs.back = Vector2(0, 1)
					state.uvs.left = Vector2(0, 1)
					state.uvs.right = Vector2(0, 1)
					state.uvs.down = Vector2(0, 2)

					maps_mrpas.set_transparent(Vector3(x, y, z), false)

				else:
					state.empty = true
					state.walkable = true
					state.tranparent = true

				cell.state = state
