extends Control

class_name ComputerUI

@onready var line_edit = $"Bootup Sequence/LineEdit"

var mouse_cursor : CompressedTexture2D = preload("res://ui/mouse_icon.png")

func _ready():
	Input.set_custom_mouse_cursor(mouse_cursor)

func _process(_delta):
	pass

func _on_line_edit_text_changed(_new_text):
	SoundBus.key_press.play()
