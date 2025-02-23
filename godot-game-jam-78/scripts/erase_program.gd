extends Control

class_name EraseProgram

@onready var program = $Program
@onready var trash = $Trash

var rng = RandomNumberGenerator.new()

var program_list : Array[String] = ["flappy_frog.exe", "typing_wizard.exe"]
var flappy_frog_exe : PackedScene = preload("res://scenes/flappy_frog_window.tscn")
var typing_wizard_exe : PackedScene = preload("res://scenes/typing_game_window.tscn")
var selected_program : String = ""
var progress_bar = null

func _ready():
	progress_bar = get_parent().get_parent().get_node("ProgressBar")
	selected_program = program_list.pick_random()
	
	if rng.randf() < 0.5:
		selected_program = scramble_text(selected_program)
	
	program.text = "Run [" + selected_program + "]"
	
func scramble_text(original_text: String) -> String:
	var chars = original_text.split("")
	
	for i in range(chars.size()):
		if rng.randf() < 0.3:
			var c = chars[i]
			
			if c.is_valid_int():
				chars[i] = str(rng.randi_range(0, 9))
			elif c.is_valid_float(): 
				chars[i] = str(rng.randi_range(0, 9)) + "."
			elif c == "_":  # Sometimes replace underscores
				chars[i] = " " if rng.randf() < 0.5 else "-"
			elif c.to_upper() != c.to_lower():  # Random letter modification
				if rng.randf() < 0.3:
					chars[i] = c.to_upper() if rng.randf() < 0.5 else c.to_lower()
				else:
					chars[i] = str(rng.randi_range(0, 9)) if rng.randf() < 0.2 else c
		
	return "".join(chars)


func _on_trash_pressed():
	get_parent().remove_child(self)
	self.queue_free()


func _on_program_pressed():
	if (selected_program == program_list[0]) or (selected_program == program_list[1]):
		if selected_program == program_list[0]:
			var flappy = flappy_frog_exe.instantiate()
			get_tree().get_root().get_node("Main").get_node("monitor").get_node("Computer Access").get_node("SubViewport").get_node("Computer UI").add_child(flappy)
			flappy.get_parent().move_child(flappy, flappy.get_parent().get_child_count() - 2)
			#print(progress_bar.value)
		if selected_program == program_list[1]:
			var typing = typing_wizard_exe.instantiate()
			get_tree().get_root().get_node("Main").get_node("monitor").get_node("Computer Access").get_node("SubViewport").get_node("Computer UI").add_child(typing)
			typing.get_parent().move_child(typing, typing.get_parent().get_child_count() - 2)
			#print(progress_bar.value)
	else:
		var jumpscare = get_tree().get_root().get_node("Main").get_node("monitor").get_node("Computer Access").get_node("Jumpscare Image")
		var tween = get_tree().create_tween()
		tween.tween_property(jumpscare, "visible", true, 0.5)
		tween.tween_property(jumpscare, "visible", false, 0.5)
		SoundBus.jumpscare_scream.play()
		ProgressSignal.increase_progress.emit(-0.1)
		
		print(progress_bar.value)
	get_parent().remove_child(self)
	self.queue_free()
