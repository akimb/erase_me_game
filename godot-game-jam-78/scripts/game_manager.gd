extends Node3D

@export var monitor : Monitor = null
@export var pc : PC = null
@export var phone : Phone = null
@export var desk_camera : DeskCamera = null
@onready var toothmonster = $toothmonster

var story_trigger : bool = false
var pause_menu_scene : PackedScene = preload("res://scenes/pause_menu.tscn")

func _ready():
	SoundBus.backrooms.play()
	SoundBus.buzzing.play()
	SoundBus.ambience.play()
	toothmonster.process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta):
	toggle_pause()
	var progress = monitor.computer_access.computer_ui.mr__erase_app.eraser_window.progress_bar
	if progress.value >= 0.5 and not story_trigger:
		toothmonster.process_mode = Node.PROCESS_MODE_INHERIT
		phone.set_continue_story()
		story_trigger = true
	elif progress.value >= 1.0:
		SoundBus.backrooms.stop()
		SoundBus.buzzing.stop()
		SoundBus.ambience.stop()
		SoundBus.phone_ring.stop()
		toothmonster.process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

func toggle_pause():
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var pause_menu := pause_menu_scene.instantiate()
		get_tree().root.add_child(pause_menu)
		get_tree().paused = true
