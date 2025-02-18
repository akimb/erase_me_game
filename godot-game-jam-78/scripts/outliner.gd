extends StaticBody3D

class_name OutlineInteraction

@export var mesh : MeshInstance3D = null

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
		mesh.material_overlay = outline
	else:
		mesh.material_overlay = null

func _destroy_outline():
	mesh.material_overlay = null

func _set_selected(object):
	selected = (object == self)
	#print(selected)

func get_object(object) -> StaticBody3D:
	if selected:
		selected_object = object
		interacted = !interacted
		selected_object.interact()
	return selected_object
	#selected_object = object
	#interacted = !interacted
	#return selected_object

func interact():
	print("Interacted with object")
