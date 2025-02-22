extends Node

signal call_ended

@onready var busy_signal = $"Busy Signal"
@onready var buzzing = $Buzzing
@onready var backrooms = $Backrooms
@onready var ambience = $Ambience
@onready var key_press = $"Key Press"
@onready var phone_ring = $"Phone Ring"
@onready var phone_call_1 = $"Phone Call 1"
@onready var phone_call_2 = $"Phone Call 2"
@onready var put_down_phone = $"Put Down Phone"
@onready var pick_up_phone = $"Pick Up Phone"
@onready var flappy_bird_wing = $"Flappy Bird Wing"
@onready var test_phone_call = $"Test Phone Call"
@onready var mouse_click = $"Mouse Click"
@onready var erase_successful = $"Erase Successful"
@onready var erase_failed = $"Erase Failed"
@onready var light_off = $"Light Off"
@onready var light_on = $"Light On"



func _on_phone_call_1_finished():
	call_ended.emit()


func _on_phone_call_2_finished():
	call_ended.emit()
