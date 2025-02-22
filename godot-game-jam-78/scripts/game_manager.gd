extends Node3D

@export var monitor : Monitor = null
@export var pc : PC = null
@export var desk_camera : DeskCamera = null

@onready var outside_nav_nodes = $"Outside Nav Nodes"

@onready var node_8 = $"Outside Nav Nodes/Node8"

enum nav_node_positions {
	NODE1,
	NODE2,
	NODE3,
	NODE4,
	NODE5,
	NODE6,
	NODE7,
	NODE8
}

var monster : PackedScene = preload("res://scenes/toothmonster.tscn")

func _ready():
	SoundBus.backrooms.play()
	SoundBus.buzzing.play()
	SoundBus.ambience.play()
	

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		#get_tree().paused = true
		print("IMPLEMENT A PAUSE MENU")
	
	#if event.is_action_pressed("jump"):
		#spawn_monster_debug()

func spawn_monster(progress_value : float):
	if progress_value >= 0.5:
		var pablo = monster.instantiate()
		pablo.global_position = node_8.global_position
		add_child(pablo)
	
func spawn_monster_debug():
	var pablo = monster.instantiate()
	#print(node_8.position)
	#pablo.position = Vector3(0, 12, 45)
	#pablo.global_position = node_8.global_position
	pablo.global_position.x = node_8.global_position.x
	pablo.global_position.y = 2.0
	pablo.global_position.z = node_8.global_position.z
	add_child(pablo)
	print(pablo.global_position)
