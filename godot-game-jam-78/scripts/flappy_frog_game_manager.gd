extends Control

class_name FlappyFrog

signal erase_success

@onready var progress_bar = $ProgressBar
@onready var panel = $Panel
@onready var success = $Success
@onready var fail = $Fail
@onready var begin = $Begin
@onready var spawn_timer = $"Spawn Timer"

var button_pressed : bool = false
var pipe : PackedScene = preload("res://scenes/pipe.tscn")

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	erase_success.connect(_full_progress_bar)
	panel.visible = false
	success.visible = false

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
	#set_process_input(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	set_physics_process(false)
	SoundBus.erase_successful.play()
	ProgressSignal.increase_progress.emit(0.1)
	panel.visible = true
	success.visible = true
	panel.get_parent().move_child(panel, panel.get_parent().get_child_count() - 1)
	success.get_parent().move_child(success, success.get_parent().get_child_count() - 1)
	var tween = get_tree().create_tween()
	tween.tween_property(success, "visible", true, 0.2)
	tween.tween_property(success, "visible", false, 0.2)
	tween.tween_property(success, "visible", true, 0.2)
	tween.tween_property(success, "visible", false, 0.2)
	tween.tween_property(success, "visible", true, 0.2)
	call_deferred("disable_game")
	await tween.finished
	get_parent().get_parent().get_parent().remove_child(self)
	get_parent().get_parent().get_parent().queue_free()
	
func disable_game():
	self.process_mode = Node.PROCESS_MODE_DISABLED

func set_instructions():
	begin.visible = true

func _input(_event):
	if Input.is_action_just_pressed("jump"):
		begin.visible = false
