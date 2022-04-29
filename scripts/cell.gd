class_name Cell


var position: Vector3
var chunk

var status: int
var light: Color

var state: CellState = CellState.new() setget set_state, get_state
var real_state: CellState = CellState.new()
var default_state: CellState = CellState.new()

var vertices: PoolIntArray


func set_state(value):
	real_state = value


func get_state():
	if status == Status.REVEALED:
		state = real_state
		return real_state
	elif status == Status.EXPLORED:
		return state
	return default_state


func _init(_chunk, _position: Vector3) -> void:
	chunk = _chunk
	position = _position
	vertices = PoolIntArray()


enum Status {
	UNKNOWN,
	EXPLORED,
	REVEALED,
}
