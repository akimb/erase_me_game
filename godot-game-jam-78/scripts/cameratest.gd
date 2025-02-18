extends Node3D

@onready var desk_camera = $"Desk Camera"

var mouse_sensitivity := 0.5
var mouseDelta := Vector2()
var minLookAngleX : float = -30.0
var maxLookAngleX : float = 30.0
var minLookAngleY : float = -45.0
var maxLookAngleY : float = 45.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	desk_camera.rotation_degrees.x -= mouseDelta.y * mouse_sensitivity
	desk_camera.rotation_degrees.x = clamp(desk_camera.rotation_degrees.x, minLookAngleX, maxLookAngleX)
	
	desk_camera.rotation_degrees.y -= mouseDelta.x * mouse_sensitivity
	desk_camera.rotation_degrees.y = clamp(desk_camera.rotation_degrees.y, minLookAngleY, maxLookAngleY)
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	
	if event.is_action_pressed("escape"):
		get_tree().quit()
		print("IMPLEMENT A PAUSE MENU")
