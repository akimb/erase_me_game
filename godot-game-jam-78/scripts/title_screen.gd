extends Control

@onready var label = $Label

var main_scene : PackedScene = preload("res://scenes/main.tscn")
@onready var controls = $CONTROLS
@onready var settings = $SETTINGS
@onready var credits = $CREDITS

@onready var return_to_menu = $"Return to Menu"

func _ready():
	SoundBus.ambience.play()
	label.release_focus()
	prepare_menu()

func _input(event):
	if Input.is_action_just_pressed("interact") and event is InputEventMouseButton:
		SoundBus.mouse_click.play()

func _on_label_text_changed(_new_text):
	SoundBus.key_press.play()


func _on_play_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_controls_pressed():
	controls.visible = true
	return_to_menu.visible = true


func _on_settings_pressed():
	settings.visible = true
	return_to_menu.visible = true


func _on_credits_pressed():
	credits.visible = true
	return_to_menu.visible = true


func _on_return_to_menu_pressed():
	prepare_menu()


func prepare_menu():
	return_to_menu.visible = false
	controls.visible = false
	settings.visible = false
	credits.visible = false
