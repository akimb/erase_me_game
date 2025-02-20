extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
#
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		SoundBus.flappy_bird_wing.play()
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body is StaticBody2D:
		print("HIT")
