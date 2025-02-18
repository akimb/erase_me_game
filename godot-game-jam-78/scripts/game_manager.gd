extends Node3D


func _ready():
	SoundBus.backrooms.play()
	SoundBus.ambience.play()

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		#get_tree().paused = true
		print("IMPLEMENT A PAUSE MENU")
