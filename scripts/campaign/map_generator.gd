extends Node

var map_scene = preload("res://scenes/map.tscn")
var chunk_scene = preload("res://scenes/chunk.tscn")

onready var campaign = get_node("/root/Main/Campaign")
onready var maps_parent = get_node("/root/Main/Campaign/Maps")


func create_scene_from_donjon(map_text):
	var parsed_text = JSON.parse(map_text)
	if parsed_text.error != OK:
		print("Error parsing Donjon map")
		return 1

	var map_data = parsed_text.result
	var cells_data = map_data["cells"]
	var len_x = 2 * cells_data[0].size()
	var len_z = 2 * cells_data.size()
	var len_chunk_x = len_x / 16 + 1
	var len_chunk_z = len_z / 16 + 1

	var map = map_scene.instance()
	map.name = map_data["settings"]["name"]
	maps_parent.add_child(map)

	var chunks_parent = map.get_node("Chunks")
	var chunks = map.chunks

	for chunk_z in range(len_chunk_z):
		for chunk_x in range(len_chunk_x):
			var base_y = -1
			var chunk = chunk_scene.instance()
			chunk.translate(Vector3(chunk_x * 16, base_y, chunk_z * 16))
			chunk.name = "Chunk__{x}_{y}_{z}".format({"x": chunk_x, "y": base_y, "z": chunk_z})
			chunk.map = map
			chunk.init_x = chunk_x * 16
			chunk.y = base_y
			chunk.init_z = chunk_z * 16
			chunks_parent.add_child(chunk)
			chunks[Vector3(chunk_x, base_y, chunk_z)] = chunk

			for z in range(16):
				for x in range(16):
					var cell: Cell = chunk.cells[z][x]

					cell.vision = Cell.Vision.REVEALED

					var state = Cell.State.new()
					state.empty = false
					state.walkable = false
					state.tranparent = false
					state.top = Vector2(0, 0)
					state.south = Vector2(0, 1)
					state.north = Vector2(0, 1)
					state.west = Vector2(0, 1)
					state.est = Vector2(0, 1)
					state.bottom = Vector2(0, 2)
					cell.set_state(state)

			for y in range(2):
				chunk = chunk_scene.instance()
				chunk.translate(Vector3(chunk_x * 16, y, chunk_z * 16))
				chunk.name = "Chunk__{x}_{y}_{z}".format({"x": chunk_x, "y": y, "z": chunk_z})
				chunk.map = map
				chunk.init_x = chunk_x * 16
				chunk.y = y
				chunk.init_z = chunk_z * 16
				chunks_parent.add_child(chunk)
				chunks[Vector3(chunk_x, y, chunk_z)] = chunk

				for z in range(16):
					for x in range(16):
						var cell: Cell = chunk.cells[z][x]
						var map_x = clamp(x + chunk_x * 16, 0, len_x - 1)
						var map_z = clamp(z + chunk_z * 16, 0, len_z - 1)
						var cell_code = cells_data[map_z / 2][map_x / 2]
						var cell_is_wall = cell_code in [0, 16]

						cell.vision = Cell.Vision.REVEALED

						var state = Cell.State.new()
						if cell_is_wall:
							state.empty = false
							state.top = Vector2(0, 2)
							state.south = Vector2(0, 1)
							state.north = Vector2(0, 1)
							state.west = Vector2(0, 1)
							state.est = Vector2(0, 1)
							state.bottom = Vector2(0, 2)
						else:
							state.walkable = true
							state.tranparent = true

						cell.set_state(state)

			var top_y = 2
			chunk = chunk_scene.instance()
			chunk.translate(Vector3(chunk_x * 16, top_y, chunk_z * 16))
			chunk.name = "Chunk__{x}_{y}_{z}".format({"x": chunk_x, "y": top_y, "z": chunk_z})
			chunk.map = map
			chunk.init_x = chunk_x * 16
			chunk.y = top_y
			chunk.init_z = chunk_z * 16
			chunks_parent.add_child(chunk)
			chunks[Vector3(chunk_x, top_y, chunk_z)] = chunk

			for z in range(16):
				for x in range(16):
					var cell: Cell = chunk.cells[z][x]

					cell.vision = Cell.Vision.REVEALED

					var state = Cell.State.new()
					state.empty = false
					state.walkable = false
					state.tranparent = false
					state.top = Vector2(0, 0)
					state.south = Vector2(0, 1)
					state.north = Vector2(0, 1)
					state.west = Vector2(0, 1)
					state.est = Vector2(0, 1)
					state.bottom = Vector2(0, 2)
					cell.set_state(state)


func create_tilemap_from_donjon(_map_text):
	pass
