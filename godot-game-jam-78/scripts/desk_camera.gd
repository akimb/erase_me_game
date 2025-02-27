extends Camera3D

class_name DeskCamera

signal look_at
signal interact

@export var monitor : StaticBody3D = null
@export var pc : StaticBody3D = null
@export var phone : StaticBody3D = null

@onready var pointer = $Pointer
@onready var desk_ui = $"Desk UI"
@onready var canvas_layer = $"Desk UI/CanvasLayer"
@onready var tutorial_zoom = $"Desk UI/Label"

var mouse_sensitivity := 0.5
var mouseDelta := Vector2()
var minLookAngleX : float = -45.0
var maxLookAngleX : float = 45.0
var minLookAngleY : float = -60.0
var maxLookAngleY : float = 60.0

var minFov : int = 30
var maxFov : int = 75

var is_looking_back : bool = false
var collider = null

func _ready():
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if pointer.is_colliding():
		collider = pointer.get_collider()
		look_at.emit(collider)
	else:
		look_at.emit(null)

func _input(event):
	if Input.is_action_just_pressed("interact") and pointer.is_colliding():
		collider = pointer.get_collider()
		interact.emit(collider)
	
	if event is InputEventMouseMotion and not is_looking_back:
		mouseDelta = event.relative
		
		self.rotation_degrees.x -= mouseDelta.y * mouse_sensitivity
		self.rotation_degrees.x = clamp(self.rotation_degrees.x, minLookAngleX, maxLookAngleX)
		
		self.rotation_degrees.y -= mouseDelta.x * mouse_sensitivity
		self.rotation_degrees.y = clamp(self.rotation_degrees.y, minLookAngleY, maxLookAngleY)
		
		mouseDelta = Vector2()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var fade_out_text = get_tree().create_tween()
			fade_out_text.tween_property(tutorial_zoom, "modulate:a", 0, 1.0)
			if self.fov > minFov:
				var zoom := get_tree().create_tween()
				zoom.tween_property(self, "fov", max(self.fov - 30, minFov), 0.2)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if self.fov < maxFov:
				var zoom := get_tree().create_tween()
				zoom.tween_property(self, "fov", min(self.fov + 30, maxFov), 0.2)
	
	if event.is_action_pressed("look left"):
		is_looking_back = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(0, 140, 0), 0.2)
	elif event.is_action_pressed("look right"):
		is_looking_back = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(0, -140, 0), 0.2)
	elif event.is_action_released("look left") or event.is_action_released("look right"):
		is_looking_back = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(0, 0, 0), 0.2)
	
	self.fov = clamp(self.fov, minFov, maxFov)
