extends OutlineInteraction

class_name LightSwitch

@export var red_light : SpotLight3D = null

@onready var spot_light_3d = $SpotLight3D
@onready var light_switch_switch = $xury_light_switch/LightSwitch_Switch

var light_on : bool = true

func _ready():
	super()
	spot_light_3d.visible = true

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		light_on = !light_on
		if light_on:
			spot_light_3d.visible = light_on
			light_switch_switch.rotation_degrees.x = -30.7
			red_light.light_energy = 1.0
			SoundBus.light_on.play()
		else:
			spot_light_3d.visible = light_on
			light_switch_switch.rotation_degrees.x = 30.7
			red_light.light_energy = 0.1
			SoundBus.light_off.play()
