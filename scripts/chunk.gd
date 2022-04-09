class_name Chunk 
extends Spatial

var dirty: bool
var map: Map
var init_x: int
var y: int
var init_z: int
var cells: Array

var verts: PoolVector3Array
var uvs: PoolVector2Array
var normals: PoolVector3Array
var indices: PoolIntArray

var atlas_material: Material
var unit_uv_x: float = 0.25
var unit_uv_y: float = 0.25


func _ready():
	dirty = true
	cells = []

	for z in range(16):
		cells.append([])

		for x in range(16):
			var cell = Cell.new()
			cell.map_x = init_x + x
			cell.map_y = y
			cell.map_z = init_z + z
			cells[z].append(cell)


func _process(_delta):
	if dirty:
		dirty = false
		refresh()


func refresh():
	refresh_mesh()


func refresh_mesh():
	verts = PoolVector3Array()
	uvs = PoolVector2Array()
	normals = PoolVector3Array()
	indices = PoolIntArray()

	for z in range(16):
		for x in range(16):
			refresh_cell_mesh(z, x)

	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices

	$MeshInstance.mesh = ArrayMesh.new()
	$MeshInstance.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	$MeshInstance.mesh.surface_set_material(0, atlas_material)


func refresh_cell_mesh(z: int, x: int):
	var cell: Cell = cells[z][x]
	var state: Cell.State = cell.state

	if not state.empty:
		var offset = Vector3(x, 0, z)
		var vertices_sequence = [0, 1, 2, 2, 1, 3]
		var indices_offset = verts.size()

		for vert in TOP:
			verts.append(offset + vert)

		for uv_point in get_uv_points(state.top):
			uvs.append(uv_point)

		for _normal in range(4):
			normals.append(Vector3.UP)

		for vertice in vertices_sequence:
			indices.append(indices_offset + vertice)

		indices_offset += 4;

		var south_cell = map.get_relative_cell_state(cell, 0, 0, 1)
		if not south_cell or south_cell.empty:
			for vert in SOUTH:
				verts.append(offset + vert)

			for uv_point in get_uv_points(state.south):
				uvs.append(uv_point)

			for _normal in range(4):
				normals.append(Vector3.FORWARD)

			for vertice in vertices_sequence:
				indices.append(indices_offset + vertice)

			indices_offset += 4;

		var north_cell = map.get_relative_cell_state(cell, 0, 0, -1)
		if not north_cell or north_cell.empty:
			for vert in NORTH:
				verts.append(offset + vert)

			for uv_point in get_uv_points(state.north):
				uvs.append(uv_point)

			for _normal in range(4):
				normals.append(Vector3.BACK)

			for vertice in vertices_sequence:
				indices.append(indices_offset + vertice)

			indices_offset += 4;

		var west_cell = map.get_relative_cell_state(cell, -1, 0, 0)
		if not west_cell or west_cell.empty:
			for vert in WEST:
				verts.append(offset + vert)

			for uv_point in get_uv_points(state.west):
				uvs.append(uv_point)

			for _normal in range(4):
				normals.append(Vector3.LEFT)

			for vertice in vertices_sequence:
				indices.append(indices_offset + vertice)

			indices_offset += 4;

		var est_cell = map.get_relative_cell_state(cell, 1, 0, 0)
		if not est_cell or est_cell.empty:
			for vert in EST:
				verts.append(offset + vert)

			for uv_point in get_uv_points(state.est):
				uvs.append(uv_point)

			for _normal in range(4):
				normals.append(Vector3.RIGHT)

			for vertice in vertices_sequence:
				indices.append(indices_offset + vertice)

			indices_offset += 4;

		var bottom_cell = map.get_relative_cell_state(cell, 0, -1, 0)
		if not bottom_cell or bottom_cell.empty:
			for vert in BOTTOM:
				verts.append(offset + vert)

			for uv_point in get_uv_points(state.bottom):
				uvs.append(uv_point)

			for _normal in range(4):
				normals.append(Vector3.DOWN)

			for vertice in vertices_sequence:
				indices.append(indices_offset + vertice)


var TOP = [Vector3(0, 1, 1), Vector3(0, 1, 0), Vector3(1, 1, 1), Vector3(1, 1, 0)]
var SOUTH = [Vector3(0, 0, 1), Vector3(0, 1, 1), Vector3(1, 0, 1), Vector3(1, 1, 1)]
var NORTH = [Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(0, 0, 0), Vector3(0, 1, 0)]
var WEST = [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 1, 1)]
var EST = [Vector3(1, 0, 1), Vector3(1, 1, 1), Vector3(1, 0, 0), Vector3(1, 1, 0)]
var BOTTOM = [Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(1, 0, 1)]


func get_uv_points(frame: Vector2):
	var init_uv_x = frame.x * unit_uv_x;
	var init_uv_y = frame.y * unit_uv_y;

	return [
		Vector2(init_uv_x, init_uv_y),
		Vector2(init_uv_x, init_uv_y + unit_uv_y),
		Vector2(init_uv_x + unit_uv_x, init_uv_y),
		Vector2(init_uv_x + unit_uv_x, init_uv_y + unit_uv_y)
	]
