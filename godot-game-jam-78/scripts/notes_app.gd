extends TextureRect

@onready var notes = $Notes
@onready var text_edit = $Notes/TextEdit

var in_notes : bool = false

func _ready():
	notes.visible = true

func _on_mouse_entered():
	in_notes = true

func _on_mouse_exited():
	in_notes = false

func _input(event):
	if event is InputEventMouseButton:
		if in_notes and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			notes.visible = true

func _on_button_pressed():
	notes.visible = false
	text_edit.release_focus()

func _on_text_edit_text_changed():
	SoundBus.key_press.play()
