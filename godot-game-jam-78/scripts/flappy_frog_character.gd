extends CharacterBody2D

@onready var progress_bar = $"../ProgressBar"

@export var progress_value = 0.1
@export var flappy_manager : FlappyFrog = null
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0.0
#
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		SoundBus.flappy_bird_wing.play()
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("ground"):
		fail_sequence()

func _on_area_2d_area_entered(area):
	if area.is_in_group("score"):
		progress_bar.value += progress_value
		flappy_manager.check_progress()
		
	elif area.is_in_group("ground"):
		fail_sequence()

func fail_sequence():
	SoundBus.erase_failed.play()
	flappy_manager.panel.visible = true
	flappy_manager.fail.visible = true
	flappy_manager.fail.text = "ERASE FAILED"
	flappy_manager.panel.get_parent().move_child(flappy_manager.panel, flappy_manager.panel.get_parent().get_child_count() - 1)
	flappy_manager.fail.get_parent().move_child(flappy_manager.fail, flappy_manager.fail.get_parent().get_child_count() - 1)
	var tween = get_tree().create_tween()
	tween.tween_property(flappy_manager.fail, "visible", true, 0.2)
	tween.tween_property(flappy_manager.fail, "visible", false, 0.2)
	tween.tween_property(flappy_manager.fail, "visible", true, 0.2)
	tween.tween_property(flappy_manager.fail, "visible", false, 0.2)
	tween.tween_property(flappy_manager.fail, "visible", true, 0.2)
	call_deferred("disable_game")

func disable_game():
	flappy_manager.spawn_timer.process_mode = Node.PROCESS_MODE_DISABLED
	process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
