extends Control
@onready var settings = $Settings
@onready var resume = $Resume
@onready var quit = $Quit


func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	settings.process_mode = Node.PROCESS_MODE_ALWAYS
	resume.process_mode = Node.PROCESS_MODE_ALWAYS
	quit.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		queue_free()

func _on_settings_pressed():
	pass

func _on_resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	queue_free()

func _on_quit_pressed():
	get_tree().quit()
