extends Control

@onready var label = $Label
@onready var controls = $CONTROLS
@onready var settings = $SETTINGS
@onready var credits = $CREDITS
@onready var settings_menu = $"SETTINGS/Settings Menu"

@onready var return_to_menu = $"Return to Menu"

var main_scene : PackedScene = preload("res://scenes/main.tscn")
var settings_scene : PackedScene = preload("res://scenes/settings_menu.tscn")

func _ready():
	SoundBus.menu_music.play()
	label.release_focus()
	prepare_menu()

func _input(event):
	if Input.is_action_just_pressed("interact") and event is InputEventMouseButton:
		SoundBus.mouse_click.play()

func _on_label_text_changed(_new_text):
	SoundBus.key_press.play()


func _on_play_pressed():
	SoundBus.menu_music.stop()
	SoundBus.parasite_goofy.stop()
	SoundBus.goofy_ahh_sound.stop()
	get_tree().change_scene_to_packed(main_scene)


func _on_controls_pressed():
	controls.visible = true
	return_to_menu.visible = true


func _on_settings_pressed():
	#var settings_node : Control = settings_scene.instantiate()
	#get_parent().add_child(settings_node)
	settings.visible = true
	settings_menu.visible = true
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
	settings_menu.visible = false

func _on_label_text_submitted(new_text):
	if new_text == "a_kimb0":
		SoundBus.parasite_goofy.play()
	elif new_text == "penis":
		SoundBus.goofy_ahh_sound.play()
