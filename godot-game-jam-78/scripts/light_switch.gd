extends OutlineInteraction

class_name LightSwitch

@onready var spot_light_3d = $SpotLight3D

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
			SoundBus.light_on.play()
		else:
			spot_light_3d.visible = light_on
			SoundBus.light_off.play()
