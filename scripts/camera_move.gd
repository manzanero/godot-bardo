extends Spatial

export var init_x: float = 5
export var init_z: float = 5
export var init_rot_x: float = -45
export var init_rot_y: float = 0
export var init_zoom: float = 10

export var move_speed: float = 0.1
export var rot_x_speed: float = 0.5
export var rot_y_speed: float = 0.5
export var zoom_step: float = 1
export var zoom_speed: float = 10

var min_x: float = 0
var max_x: float = 100
var min_z: float = 0
var max_z: float = 100
var min_rot_x: float = -90
var max_rot_x: float = 90
var zoom: float = 1
var min_zoom: float = 1
var max_zoom: float = 100

var is_action: bool
var is_move: bool
var is_rotate: bool
var offset_move: Vector2
var offset_wheel: int


func _ready():
	transform.origin = Vector3(init_x, 0, init_z)
	rotation_degrees.x = clamp(init_rot_x, min_rot_x, max_rot_x)
	rotation_degrees.y = init_rot_y
	$Camera.transform.origin.z = clamp(init_zoom, min_zoom, max_zoom)


func _process(delta):

	is_action = Input.is_action_pressed("left_click")
	is_move = Input.is_action_pressed("right_click")
	is_rotate = Input.is_action_pressed("middle_click") and not (is_move or is_action)

	if is_rotate:
		var new_rotation = rotation_degrees + \
			Vector3(-offset_move.y * rot_y_speed, offset_move.x * rot_x_speed, 0)

		new_rotation.x = clamp(new_rotation.x, min_rot_x, max_rot_x)

		rotation_degrees = new_rotation

	if is_move:
		var transform_forward = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		var transform_left = Vector3.LEFT.rotated(Vector3.UP, rotation.y)
		var new_origin = transform.origin + \
			move_speed * (offset_move.y * transform_forward + offset_move.x * transform_left)

		new_origin.x = clamp(new_origin.x, min_x, max_x)
		new_origin.z = clamp(new_origin.z, min_z, max_z)

		transform.origin = new_origin

	offset_move = Vector2.ZERO

	$Camera.transform.origin.z = lerp($Camera.transform.origin.z, zoom * zoom, zoom_speed * delta)


func _input(event):
	if event is InputEventMouseMotion:
		offset_move += event.relative

	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_WHEEL_UP:
				zoom -= zoom_step
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom += zoom_step
			zoom = clamp(zoom, min_zoom, max_zoom)
