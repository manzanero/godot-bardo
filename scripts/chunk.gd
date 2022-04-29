extends MeshInstance

var dirty: bool
var map
var offset: Vector3

var verts: PoolVector3Array
var colors: PoolColorArray
var uvs: PoolVector2Array
var normals: PoolVector3Array
var indices: PoolIntArray

var face = CellFace.new()
var atlas_material: Material
var unit_uv_x: float = 0.25
var unit_uv_y: float = 0.25


func chunk_to_map(chunk_cell: Vector3):
	return Vector3(
		offset.x + chunk_cell.x,
		offset.y + chunk_cell.y,
		offset.z + chunk_cell.z
	)


func new(_map, _offset: Vector3):
	map = _map
	offset = _offset
	map.chunks[offset] = self
	translate(offset)
	name = "Chunk__%s" % offset

	for z in range(16):
		for x in range(16):
			var cell = Cell.new(self, Vector3(offset.x + x, offset.y, offset.z + z))
			map.cells[cell.position] = cell

	return self


func _ready():
	dirty = true


func _process(_delta):
	if dirty:
		dirty = false
		refresh()


func refresh():
	refresh_mesh()


func refresh_mesh():
	verts = PoolVector3Array()
	colors = PoolColorArray()
	uvs = PoolVector2Array()
	normals = PoolVector3Array()
	indices = PoolIntArray()

	for z in range(16):
		for x in range(16):
			var cell = map.get_cell(Vector3(offset.x + x, offset.y, offset.z + z))
			refresh_cell_mesh(cell)

	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_COLOR] = colors
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices

	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	mesh.surface_set_material(0, atlas_material)


func refresh_cell_mesh(cell: Cell):
	var cell_offset = cell.position - offset
	var state: CellState = cell.state

	var color: Color
	if cell.status == Cell.Status.REVEALED:
		color = Color.white
	elif cell.status == Cell.Status.EXPLORED:
		color = Color.gray
	else:
		return

	var up_cell: Cell = map.get_cell(cell.position + Vector3.UP)
	var forward_cell: Cell = map.get_cell(cell.position + Vector3.FORWARD)
	var back_cell: Cell = map.get_cell(cell.position + Vector3.BACK)
	var left_cell: Cell = map.get_cell(cell.position + Vector3.LEFT)
	var right_cell: Cell = map.get_cell(cell.position + Vector3.RIGHT)
	var down_cell: Cell = map.get_cell(cell.position + Vector3.DOWN)

	if up_cell and up_cell.state.empty:
		draw_face(cell_offset, color, face.UP, Vector3.UP, state.uvs.up)

	if forward_cell and forward_cell.state.empty:
		draw_face(cell_offset, color, face.FORWARD, Vector3.FORWARD, state.uvs.forward)

	if back_cell and back_cell.state.empty:
		draw_face(cell_offset, color, face.BACK, Vector3.BACK, state.uvs.back)

	if left_cell and left_cell.state.empty:
		draw_face(cell_offset, color, face.LEFT, Vector3.LEFT, state.uvs.left)

	if right_cell and right_cell.state.empty:
		draw_face(cell_offset, color, face.RIGHT, Vector3.RIGHT, state.uvs.right)

	if down_cell and down_cell.state.empty:
		draw_face(cell_offset, color, face.DOWN, Vector3.DOWN, state.uvs.down)


func draw_face(cell_offset, color, face_vertices, face_normal, uv_frame):
	var indices_offset = verts.size()

	for vert in face_vertices:
		verts.append(cell_offset + vert)
		normals.append(face_normal)
		colors.append(color)

	for uv_point in get_uv_points(uv_frame):
		uvs.append(uv_point)

	for vertice in face.SEQUENCE:
		indices.append(indices_offset + vertice)


func get_uv_points(frame: Vector2):
	var init_uv_x = frame.x * unit_uv_x;
	var init_uv_y = frame.y * unit_uv_y;

	return [
		Vector2(init_uv_x, init_uv_y),
		Vector2(init_uv_x, init_uv_y + unit_uv_y),
		Vector2(init_uv_x + unit_uv_x, init_uv_y),
		Vector2(init_uv_x + unit_uv_x, init_uv_y + unit_uv_y)
	]
