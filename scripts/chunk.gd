class_name Chunk
extends Spatial

var dirty: bool

var map: Map
var position: Vector3

var verts: PoolVector3Array
var uvs: PoolVector2Array
var normals: PoolVector3Array
var indices: PoolIntArray

var atlas_material: Material
var unit_uv_x: float = 0.25
var unit_uv_y: float = 0.25


func chunk_to_map(chunk_cell: Vector3):
	return Vector3(
		position.x * 16 + chunk_cell.x,
		position.y + chunk_cell.y,
		position.z * 16 + chunk_cell.z
	)


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
	uvs = PoolVector2Array()
	normals = PoolVector3Array()
	indices = PoolIntArray()

	for z in range(16):
		for x in range(16):
			refresh_cell_mesh(Vector3(x, 0, z))

	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices

	$MeshInstance.mesh = ArrayMesh.new()
	$MeshInstance.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	$MeshInstance.mesh.surface_set_material(0, atlas_material)


func refresh_cell_mesh(offset):
	var cell: Cell = map.get_cell(chunk_to_map(offset))
	var state: CellState = cell.state

	if not state.empty:

		var up_state: CellState = map.get_relative_cell_state(cell, Vector3.UP)
		var forward_state: CellState = map.get_relative_cell_state(cell, Vector3.FORWARD)
		var back_state: CellState = map.get_relative_cell_state(cell, Vector3.BACK)
		var left_state: CellState = map.get_relative_cell_state(cell, Vector3.LEFT)
		var right_state: CellState = map.get_relative_cell_state(cell, Vector3.RIGHT)
		var down_state: CellState = map.get_relative_cell_state(cell, Vector3.DOWN)

		if not up_state or up_state.empty:
			draw_face(offset, FACE_UP, Vector3.UP, state.uvs.up)

		if not forward_state or forward_state.empty:
			draw_face(offset, FACE_FORWARD, Vector3.FORWARD, state.uvs.forward)

		if not back_state or back_state.empty:
			draw_face(offset, FACE_BACK, Vector3.BACK, state.uvs.back)

		if not left_state or left_state.empty:
			draw_face(offset, FACE_LEFT, Vector3.LEFT, state.uvs.left)

		if not right_state or right_state.empty:
			draw_face(offset, FACE_RIGHT, Vector3.RIGHT, state.uvs.right)

		if not down_state or down_state.empty:
			draw_face(offset, FACE_DOWN, Vector3.DOWN, state.uvs.down)


func draw_face(offset, face_verts, face_normal, uv_frame):
	var indices_offset = verts.size()

	for vert in face_verts:
		verts.append(offset + vert)
		normals.append(face_normal)

	for uv_point in get_uv_points(uv_frame):
		uvs.append(uv_point)

	for vertice in FACE_SEQUENCE:
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


var FACE_SEQUENCE = [0, 1, 2, 2, 1, 3]
var FACE_UP = [Vector3(0, 1, 1), Vector3(0, 1, 0), Vector3(1, 1, 1), Vector3(1, 1, 0)]
var FACE_FORWARD = [Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(0, 0, 0), Vector3(0, 1, 0)]
var FACE_BACK = [Vector3(0, 0, 1), Vector3(0, 1, 1), Vector3(1, 0, 1), Vector3(1, 1, 1)]
var FACE_LEFT = [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 1, 1)]
var FACE_RIGHT = [Vector3(1, 0, 1), Vector3(1, 1, 1), Vector3(1, 0, 0), Vector3(1, 1, 0)]
var FACE_DOWN = [Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(1, 0, 1)]
