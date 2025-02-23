extends Control

func _ready():
	SoundBus.bsod.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _input(_event):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
		SoundBus.bsod.stop()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("pause"):
		get_tree().quit()
