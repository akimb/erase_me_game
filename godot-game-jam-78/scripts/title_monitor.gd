extends StaticBody3D

@onready var node_quad = $Node3D/MeshInstance3D
@onready var node_viewport = $Node3D/SubViewport
@onready var node_area = $Node3D/Area3D

var is_mouse_inside : bool = true
var last_event_pos2D = null
var last_event_time: float = -1.0

func _ready():
	node_area.input_event.connect(_mouse_input_event)

func _input(event):
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			return
	
	if node_viewport and node_viewport.is_inside_tree():
		node_viewport.push_input(event)

func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if not (node_viewport and node_viewport.is_inside_tree()):
		return
	
	var quad_mesh_size = node_quad.mesh.size
	var event_pos3D = event_position

	var now: float = Time.get_ticks_msec() / 1000.0

	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D

	var event_pos2D: Vector2 = Vector2()

	if is_mouse_inside:
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y

	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D
	else:
		return

	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)
	last_event_pos2D = event_pos2D
	last_event_time = now
	
	if node_viewport and node_viewport.is_inside_tree():
		node_viewport.push_input(event)
