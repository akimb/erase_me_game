extends OutlineInteraction

@export var desk_camera : DeskCamera = null
@onready var computer_access = $"Computer Access"

func _ready():
	super()

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		print("Monitor Selected")
		_destroy_outline()
		desk_camera.process_mode = PROCESS_MODE_DISABLED
		desk_camera.desk_ui.visible = false
		desk_camera.canvas_layer.visible = false
		computer_access.diegetic_camera.current = true
		computer_access.set_desk_camera(desk_camera)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		selected_object = null
		selected = false
