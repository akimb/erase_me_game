extends Control

class_name ComputerUI

signal bootup_finished

@export var monitor : Monitor = null
@onready var bootup_sequence = $"Bootup Sequence"
@onready var user_ui = $"User UI"
@onready var rich_text_label = $"Bootup Sequence/RichTextLabel"

var mouse_cursor : CompressedTexture2D = preload("res://ui/mouse_icon.png")
var line_delay : float = 0.05
var boot_up : bool = false

func _ready():
	Input.set_custom_mouse_cursor(mouse_cursor)
	user_ui.visible = false
	user_ui.process_mode = Node.PROCESS_MODE_DISABLED

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		SoundBus.mouse_click.play()
	
	if Input.is_action_just_pressed("enter") and boot_up == false:
		bootup_sequence.visible = false
		user_ui.visible = true
		user_ui.process_mode = Node.PROCESS_MODE_INHERIT
		bootup_sequence.process_mode = Node.PROCESS_MODE_DISABLED

func start_bootup_animation():
	boot_up = true
	var lines = rich_text_label.text.split("\n") 
	rich_text_label.text = ""
	var tween = get_tree().create_tween()
	tween.set_parallel(false)
	
	var accumulated_text = ""
	for i in range(lines.size()):
		accumulated_text += lines[i] + "\n" 
		tween.tween_callback(set_text.bind(accumulated_text))
		tween.tween_interval(line_delay)
	
	tween.tween_callback(_on_tween_finished)

func set_text(new_text: String):
	rich_text_label.text = new_text

func _on_tween_finished():
	boot_up = false
	bootup_finished.emit()
