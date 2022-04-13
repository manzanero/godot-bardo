class_name Cell

var position: Vector3
var chunk

enum Status {
	UNKNOWN,
	EXPLORED,
	REVEALED,
}

var status: int
var light: Color

var state: CellState setget set_state, get_state
var real_state: CellState


func set_state(new_state: CellState):
	real_state = new_state


func get_state() -> CellState:
	if status == Status.REVEALED:
		state = real_state
		return real_state
	elif status == Status.EXPLORED:
		return state
	return null


func _init(_chunk, _position: Vector3) -> void:
	chunk = _chunk
	position = _position
