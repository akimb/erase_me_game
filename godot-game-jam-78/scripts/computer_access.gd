extends Node3D

@export var computer_ui : ComputerUI = null

@onready var diegetic_camera = $Camera
@onready var node_area = $Area3D
@onready var node_viewport = $SubViewport
@onready var node_quad = $BlueScreen
@onready var camera = $Camera

var is_mouse_inside : bool = false
var last_event_pos2D = null
var last_event_time: float = -1.0

var minFov : int = 60
var maxFov : int = 90

var desk_camera : DeskCamera = null

func _ready():
	node_area.input_event.connect(_mouse_input_event)
	computer_ui.set_process_input(true)

func _on_area_3d_mouse_entered():
	if diegetic_camera.current:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		is_mouse_inside = true

func _on_area_3d_mouse_exited():
	if diegetic_camera.current:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		is_mouse_inside = false

func set_desk_camera(curr_camera : DeskCamera):
	desk_camera = curr_camera

func _reset_camera():
	camera.fov = maxFov

func _input(event):
	if event.is_action_pressed("go_to_first_person"):
		if desk_camera:
			desk_camera.process_mode = PROCESS_MODE_INHERIT
			diegetic_camera.current = false
			desk_camera.desk_ui.visible = true
			desk_camera.canvas_layer.visible = true
			desk_camera.current = true
			#computer_ui.line_edit.release_focus()
			computer_ui.set_process_input(false)
			Input.warp_mouse(DisplayServer.window_get_size() / 2)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if camera.fov > minFov:
				var zoom := get_tree().create_tween()
				zoom.tween_property(camera, "fov", max(camera.fov - 30, minFov), 0.2)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if camera.fov < maxFov:
				var zoom := get_tree().create_tween()
				zoom.tween_property(camera, "fov", min(camera.fov + 30, maxFov), 0.2)
	
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			return
	node_viewport.push_input(event)

func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
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
	node_viewport.push_input(event)
