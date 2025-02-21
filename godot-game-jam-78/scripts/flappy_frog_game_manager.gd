extends Control

class_name FlappyFrog

signal erase_success

@onready var progress_bar = $ProgressBar
@onready var panel = $Panel
@onready var label = $Label

var pipe : PackedScene = preload("res://scenes/pipe.tscn")

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	erase_success.connect(_full_progress_bar)
	panel.visible = false
	label.visible = false

func spawnPipe():
	var pipeInstance = pipe.instantiate()
	pipeInstance.position = Vector2(320, randi_range(106,178))
	add_child(pipeInstance)

func _on_spawn_timer_timeout():
	spawnPipe()

func check_progress():
	if progress_bar.value >= 1.0:
		erase_success.emit()

func _full_progress_bar():
	panel.visible = true
	label.visible = true
	label.text = "ERASE SUCCESSFUL"
	panel.get_parent().move_child(panel, panel.get_parent().get_child_count() - 1)
	label.get_parent().move_child(label, label.get_parent().get_child_count() - 1)
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible", true, 0.2)
	tween.tween_property(label, "visible", false, 0.2)
	tween.tween_property(label, "visible", true, 0.2)
	tween.tween_property(label, "visible", false, 0.2)
	tween.tween_property(label, "visible", true, 0.2)
	process_mode = Node.PROCESS_MODE_DISABLED
