extends Control

var dragging_distance
var dir
var dragging
var offset = Vector2.ZERO
var mouse_in : bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and mouse_in:
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
