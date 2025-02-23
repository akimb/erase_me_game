extends Control

@onready var resume = $Resume
@onready var quit = $Quit
@onready var sfx_slider = $"SFX Slider"
@onready var label = $Label

var settings_scene : PackedScene = preload("res://scenes/settings_menu.tscn")

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	resume.process_mode = Node.PROCESS_MODE_ALWAYS
	quit.process_mode = Node.PROCESS_MODE_ALWAYS
	sfx_slider.value = ProgressSignal.default_val

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		queue_free()

func _on_resume_pressed():
	sfx_slider.visible = false
	label.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	queue_free()

func _on_quit_pressed():
	get_tree().quit()


func _on_sfx_slider_value_changed(value):
	var idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(idx, linear_to_db(sfx_slider.value))
	ProgressSignal.default_val = sfx_slider.value
