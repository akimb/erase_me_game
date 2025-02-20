extends StaticBody2D


@export var speed := 100

func _physics_process(delta):
	self.position.x -= speed * delta
