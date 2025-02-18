extends OutlineInteraction

@export var desk_camera : DeskCamera = null

func _ready():
	super()

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		print("PC Selected")
		selected_object = null
		selected = false
