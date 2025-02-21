extends OutlineInteraction

class_name Monitor

@export var desk_camera : DeskCamera = null

@onready var computer_access = $"Computer Access"
@onready var computer_light = $"Computer Light"

func _ready():
	super()

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		_destroy_outline()
		desk_camera.process_mode = PROCESS_MODE_DISABLED
		desk_camera.desk_ui.visible = false
		desk_camera.canvas_layer.visible = false
		computer_access.diegetic_camera.current = true
		computer_access.set_desk_camera(desk_camera)
		computer_access.computer_ui.set_process_input(true)
		computer_access._reset_camera()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		selected_object = null
		selected = false
