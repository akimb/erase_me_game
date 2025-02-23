extends Control

@onready var label_output = $RichTextLabel
@onready var timer = $Timer

var lines = [
	"> INITIALIZING SYSTEM CHECK...",
	"> SCANNING FILES... SUCCESS",
	"> VALIDATING USER INPUT... SUCCESS",
	"> EXECUTING FINAL SEQUENCE...",
	"",
	"> CONGRATULATIONS, OPERATOR.",
	"> ALL TARGET DATA HAS BEEN SUCCESSFULLY ERASED.",
	"> NO TRACE REMAINS.",
	"",
	"> SYSTEM SELF-PURGE IN PROGRESS... SUCCESS",
	"> DISCONNECTING FROM SECURE NETWORK...",
	"> CLOSING CONNECTION...",
	"",
	"> YOU WIN.",
	"",
	"> PRESS ANY KEY TO EXIT."
]
# ▒ █
var line := 0
var ended_lines := false

func _ready():
	timer.start()
	label_output.text = ""

func display_new_line():
	if line < lines.size():
		label_output.text += lines[line] + "\n"
		line += 1
	elif line >= lines.size():
		ended_lines = true

func _on_timer_timeout():
	display_new_line()

func _input(event):
	if Input.is_anything_pressed() and ended_lines:
		get_tree().quit()
