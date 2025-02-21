extends Control

@onready var label = $Label

var main_scene : PackedScene = preload("res://scenes/main.tscn")

func _ready():
	label.release_focus()


func _on_label_text_changed(_new_text):
	SoundBus.key_press.play()


func _on_button_pressed():
	get_tree().change_scene_to_packed(main_scene)
