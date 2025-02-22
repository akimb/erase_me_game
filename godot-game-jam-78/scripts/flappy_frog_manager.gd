extends Control

class_name FlappyManager

@export var flappy_frog : FlappyFrog = null
@onready var pause_screen = $"Pause Screen"
@onready var play_button = $"Play Button"

var dragging_distance
var dir
var dragging
var offset = Vector2.ZERO
var mouse_in : bool = false

func _ready():
	pause_screen.visible = true
	play_button.visible = true

func _input(event):
	if Input.is_action_just_pressed("jump"):
		flappy_frog.process_mode = Node.PROCESS_MODE_INHERIT
	if event is InputEventMouseButton:
		if event.pressed and mouse_in:
			self.get_parent().move_child(self, self.get_parent().get_child_count() - 2)
			offset = get_global_mouse_position() - global_position
			dragging = true
		elif event.is_released():
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		var new_position = get_global_mouse_position() - offset
		global_position = clamp_to_bounds(new_position)

func clamp_to_bounds(pos: Vector2) -> Vector2:
	var parent_rect = get_parent().size
	var max_size = get_rect().size
	
	pos.x = clamp(pos.x, 0, parent_rect.x - max_size.x)
	pos.y = clamp(pos.y, 0, parent_rect.y - max_size.y)

	return pos

func _on_toolbar_mouse_entered():
	mouse_in = true

func _on_toolbar_mouse_exited():
	mouse_in = false

func _on_button_pressed():
	get_parent().remove_child(self)
	self.queue_free()

func _on_play_button_pressed():
	pause_screen.visible = false
	play_button.visible = false
	flappy_frog.set_instructions()
