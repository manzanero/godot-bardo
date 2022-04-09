class_name Cell

var map_x: int
var map_y: int
var map_z: int

enum Vision {
	UNKNOWN,
	EXPLORED,
	REVEALED,
}

var vision: int
var light: Color

var state: State setget set_state, get_state
var _cached_state: State
var _real_state: State


class State:
	var empty: bool = true
	var walkable: bool
	var tranparent: bool
	var top: Vector2
	var south: Vector2
	var north: Vector2
	var west: Vector2
	var est: Vector2
	var bottom: Vector2


func set_state(state: State):
	_real_state = state


func get_state() -> State:
	if vision == Vision.REVEALED:
		_cached_state = _real_state
		return _real_state
	elif vision == Vision.EXPLORED:
		return _cached_state
	else:
		return State.new()
