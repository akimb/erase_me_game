extends OutlineInteraction

class_name PC

@export var monitor : Monitor = null
@export var desk_camera : DeskCamera = null

@onready var pc_indicator = $"PC Indicator"

var green : StandardMaterial3D = preload("res://resources/pc_on.tres")
var red : StandardMaterial3D = preload("res://resources/pc_off.tres")

func _ready():
	super()
	pc_indicator.material_overlay = red
	monitor.computer_access.visible = false
	monitor.computer_light.visible = false

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		SoundBus.pc_button.play()
		var ui = monitor.computer_access.computer_ui
		monitor.computer_access.visible = !monitor.computer_access.visible
		monitor.computer_light.visible = !monitor.computer_light.visible
		
		ui.bootup_sequence.visible = true
		ui.start_bootup_animation()
		ui.user_ui.visible = false
		ui.user_ui.process_mode = Node.PROCESS_MODE_DISABLED
		
		if monitor.computer_light.visible:
			pc_indicator.material_overlay = green
		else:
			pc_indicator.material_overlay = red
		
		selected_object = null
		selected = false
