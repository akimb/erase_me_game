extends Node3D

@export var monitor : Monitor = null
@export var pc : PC = null
@export var desk_camera : DeskCamera = null

func _ready():
	SoundBus.backrooms.play()
	SoundBus.ambience.play()

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		#get_tree().paused = true
		print("IMPLEMENT A PAUSE MENU")
