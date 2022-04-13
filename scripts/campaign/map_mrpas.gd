class_name MapMRPAS
extends Node

var offset: Vector3
var size: Vector3
var levels: Array


func init(_offset: Vector3, _size: Vector3):
	offset = _offset
	size = _size
	refresh()
	return self


func refresh():
	levels.clear()
	for i in range(size.y):
		levels.append(MRPAS.new(Vector2(size.x, size.z)))


func set_transparent(position: Vector3, transparent: bool) -> void:
	position = position - offset
	levels[position.y].set_transparent(Vector2(position.x, position.z), transparent)


func field_of_view(position: Vector3) -> PoolVector3Array:
	position = position - offset
	var mrpas = levels[position.y]
	mrpas.clear_field_of_view()
	mrpas.compute_field_of_view(Vector2(position.x, position.z), 30)

	var fov = []
	for j in range(mrpas._fov_cells.size()):
		for i in range(mrpas._fov_cells[j].size()):
			if mrpas._fov_cells[j][i]:
				fov.append(Vector3(i, position.y, j) + offset)
	return fov
