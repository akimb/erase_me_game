extends Control

class_name MrErase

@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $ProgressBar

var dragging_distance
var dir
var dragging
var offset = Vector2.ZERO
var mouse_in : bool = false

func _ready():
	animation_player.play("spin_hourglass")
	progress_bar.value = 0.0
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and mouse_in:
			self.get_parent().move_child(self, self.get_parent().get_child_count() - 1)
			offset = get_global_mouse_position() - global_position
			dragging = true
		elif event.is_released():
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		var new_position = get_global_mouse_position() - offset
		global_position = clamp_to_bounds(new_position)

func clamp_to_bounds(pos: Vector2) -> Vector2:
	var parent_rect = get_parent().get_parent().size
	var max_size = get_rect().size
	
	pos.x = clamp(pos.x, 0, parent_rect.x - max_size.x)
	pos.y = clamp(pos.y, 0, parent_rect.y - max_size.y)

	return pos

func _on_toolbar_mouse_entered():
	mouse_in = true

func _on_toolbar_mouse_exited():
	mouse_in = false

func _on_button_pressed():
	self.visible = false
