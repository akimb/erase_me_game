extends Control

var pipe : PackedScene = preload("res://scenes/pipe.tscn")


func spawnPipe():
	var pipeInstance = pipe.instantiate()
	pipeInstance.position = Vector2(320, randi_range(106,178))
	add_child(pipeInstance)

func _on_spawn_timer_timeout():
	spawnPipe()
