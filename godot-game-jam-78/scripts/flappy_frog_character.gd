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
		print("HIT")

func _on_area_2d_area_entered(area):
	if area.is_in_group("score"):
		progress_bar.value += progress_value
		flappy_manager.check_progress()
		
	elif area.is_in_group("ground"):
		print("HIT")
