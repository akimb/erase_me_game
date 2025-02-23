extends Node

signal increase_progress

var default_val : float = 0.5

func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_val))
