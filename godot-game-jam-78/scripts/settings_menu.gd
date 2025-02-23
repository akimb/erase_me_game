extends Control

@export var get_parent_node : Node = null

@onready var sfx_slider = $"SFX Slider"
@onready var mouse_sensitivity_slider = $"Mouse Sensitivity Slider"

var default_val : float = 0.5

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_val))
	sfx_slider.value = default_val
	mouse_sensitivity_slider.value = default_val

func _on_sfx_slider_value_changed(value):
	var idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(idx, linear_to_db(sfx_slider.value))
	ProgressSignal.default_val = sfx_slider.value


func _on_mouse_sensitivity_slider_value_changed(value):
	pass # Replace with function body.



func _on_button_pressed():
	#if get_parent_node != null:
		#get_parent().get_parent_node.visible = false
	queue_free()
