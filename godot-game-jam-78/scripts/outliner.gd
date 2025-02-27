extends StaticBody3D

class_name OutlineInteraction

#@export var mesh : MeshInstance3D = null
@export var mesh_array : Array[MeshInstance3D] = []

var outline : ShaderMaterial = preload("res://resources/outline_material.tres")
var selected : bool = false
var selected_object : StaticBody3D = null
var interacted : bool = false

func _ready():
	get_tree().get_first_node_in_group("player").look_at.connect(_set_selected)
	get_tree().get_first_node_in_group("player").interact.connect(get_object)
	#mesh = get_child(0)

#func _process(_delta):
	#_update_outline()

func _update_outline():
	if selected:
		for meshes in mesh_array:
			meshes.material_overlay = outline
	else:
		for meshes in mesh_array:
			meshes.material_overlay = null

func _destroy_outline():
	for meshes in mesh_array:
			meshes.material_overlay = null
	#mesh.material_overlay = null

func _set_selected(object):
	selected = (object == self)
	#print(selected)

func get_object(object) -> StaticBody3D:
	if selected:
		selected_object = object
		interacted = !interacted
		selected_object.interact()
	return selected_object

func reset_object():
	if selected:
		selected_object = null
		interacted = false

func interact():
	print("Interacted with object")
