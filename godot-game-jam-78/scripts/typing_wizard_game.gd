extends Control

class_name TypingWizard

@onready var rich_text_label = $RichTextLabel
@onready var text_edit = $TextEdit
@onready var progress_bar = $ProgressBar
@onready var panel = $Panel
@onready var success = $Success
@onready var fail = $Fail
@onready var invalid = $Invalid

var possible_texts = {
	0 : "The air was musty and stale, and I could hear the creaking of the floorboards beneath my feet.",
	1 : "The snow was falling softly outside, creating a winter wonderland. I snuggled up by the fire with a cup of hot cocoa, feeling cozy and content.",
	2 : "As I entered the old, abandoned house I couldn't help but feel a sense of unease wash over me.",
	3 : "for(int i = 0; i < len; i++)\nr.push_back(a.at(size_t(rand()\n% 62)));",
	4 : "Every day, he was there. Every night, he wouldn't leave. So I made sure he never would.",
	5 : "THE QUICK BROWN FOX BLEEDS TO DEATH ON THE COLD SURFACE OF THE MOON.",
	6 : "@onready var collision_zone :\nArea2D = $Area2D",
	7 : "for i in\nrange(text_edit.text.length()):\nif i >= target_text.length():\nbreak",
	8 : "LOOK BEHIND YOU.",
	9 : "DEBUG"
}

var rng = RandomNumberGenerator.new()
var target_text : String = ""
var elapsed_time : float = 0.0
var have_clicked : bool = false
var all_currently_correct : bool = true
var match_text : String = ""
var count_down_progress : Tween = null

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	rich_text_label.text = "[color=black]Click to begin program.[/color]"

func visualize_timer():
	if have_clicked:
		return
	else:
		var choose_text = rng.randi_range(0, len(possible_texts) - 2)
		target_text = possible_texts[choose_text]
		rich_text_label.text = "[color=black]" + target_text + "[/color]"
		text_edit.text = ""
		
		count_down_progress = get_tree().create_tween()
			
		count_down_progress.tween_property(progress_bar, "value", 1.0, 0)
		match choose_text:
			0: count_down_progress.tween_property(progress_bar, "value", 0.0, 60)
			
			2: count_down_progress.tween_property(progress_bar, "value", 0.0, 60)
			
			_: count_down_progress.tween_property(progress_bar, "value", 0.0, 40)
		
		if process_mode == Node.PROCESS_MODE_DISABLED:
			count_down_progress.kill()
		

func _on_text_edit_text_changed():
	var current_input = text_edit.text
	match_text = ""

	for i in range(current_input.length()):
		if i < target_text.length() and current_input[i] == target_text[i]:
			match_text += current_input[i]
		else:
			break

	if match_text == current_input:
		rich_text_label.text = "[color=black]" + target_text + "[/color]"
	else:
		rich_text_label.text = "[color=red]" + target_text + "[/color]"

	SoundBus.key_press.play()

func _on_button_pressed():
	var cleaned_input_text : String = text_edit.text
	if cleaned_input_text.rstrip(" \n\r\t") == target_text:
		end_condition(true)
	else:
		display_invalid()

func _on_button_2_pressed():
	#have_clicked = true
	visualize_timer()
	have_clicked = false

func _on_text_edit_focus_entered():
	visualize_timer()
	have_clicked = true

func display_invalid():
	panel.visible = true
	invalid.visible = true
	panel.get_parent().move_child(panel, panel.get_parent().get_child_count() - 1)
	invalid.get_parent().move_child(invalid, invalid.get_parent().get_child_count() - 1)
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "visible", true, 0.2)
	tween.tween_property(invalid, "visible", true, 0.2)
	tween.tween_property(invalid, "visible", false, 0.2)
	tween.tween_property(invalid, "visible", true, 0.2)
	tween.tween_property(invalid, "visible", false, 0.2)
	tween.tween_property(invalid, "visible", true, 0.5)
	tween.tween_property(invalid, "visible", false, 0.2)
	tween.tween_property(panel, "visible", false, 0.2)

func end_condition(cond : bool):
	panel.visible = true
	
	if cond:
		SoundBus.erase_successful.play()
		count_down_progress.kill()
		success.visible = true
		panel.get_parent().move_child(panel, panel.get_parent().get_child_count() - 1)
		success.get_parent().move_child(success, success.get_parent().get_child_count() - 1)
		ProgressSignal.increase_progress.emit(0.1)
		var tween = get_tree().create_tween()
		tween.tween_property(success, "visible", true, 0.2)
		tween.tween_property(success, "visible", false, 0.2)
		tween.tween_property(success, "visible", true, 0.2)
		tween.tween_property(success, "visible", false, 0.2)
		tween.tween_property(success, "visible", true, 0.2)
		await tween.finished
		print("hi")
	else:
		SoundBus.erase_failed.play()
		fail.visible = true
		panel.get_parent().move_child(panel, panel.get_parent().get_child_count() - 1)
		fail.get_parent().move_child(fail, fail.get_parent().get_child_count() - 1)
		var tween = get_tree().create_tween()
		tween.tween_property(fail, "visible", true, 0.2)
		tween.tween_property(fail, "visible", false, 0.2)
		tween.tween_property(fail, "visible", true, 0.2)
		tween.tween_property(fail, "visible", false, 0.2)
		tween.tween_property(fail, "visible", true, 0.2)
		await tween.finished
	get_parent().get_parent().remove_child(self)
	get_parent().queue_free()

func _on_progress_bar_value_changed(value):
	if value <= 0.0:
		end_condition(false)
