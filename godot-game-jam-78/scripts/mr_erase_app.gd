extends TextureRect

@onready var eraser_window = $"Eraser Window"

var in_eraser : bool = false
var offset : Vector2 = Vector2(200, 128)
var mr_eraser : PackedScene = preload("res://scenes/eraser_window.tscn")
#var exists : bool = false
#
func _ready():
	eraser_window.visible = false
	#exists = false

func _input(event):
	if event is InputEventMouseButton:
		if in_eraser and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			eraser_window.visible = true
			#pass
			#var erase_app = mr_eraser.instantiate()
			#get_tree().get_root().get_node("Main").get_node("monitor").get_node("Computer Access").get_node("SubViewport").get_node("Computer UI").add_child(erase_app)
			#erase_app.get_parent().move_child(erase_app, erase_app.get_parent().get_child_count() - 2)


func _on_mouse_entered():
	in_eraser = true


func _on_mouse_exited():
	in_eraser = false
