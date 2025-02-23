extends Node3D

@export var light_switch : LightSwitch = null
@export var monitor : Monitor = null
@export var phone : Phone = null
@export var pc : PC = null

@export var monster_nav_agent : NavigationAgent3D = null
@export var outside_waypoints_parent : Node3D = null
@export var inside_waypoints_parent : Node3D = null
@export var doorway_node : Node3D = null

@export var player_camera : DeskCamera = null

@onready var scary_music = $AudioStreamPlayer3D
@onready var outside_last_node : Node3D = outside_waypoints_parent.get_node("OutsideNode8")

var bsod : PackedScene = preload("res://scenes/death_scene.tscn")

var eraseme : AudioStream = preload("res://sounds/eraseme.ogg")
var erasemescary : AudioStream = preload("res://sounds/erasemescary.ogg")

enum MonsterState {
	PATROLLING_OUTSIDE,
	PATROLLING_INSIDE,
	ENTER_DOORWAY,
	EXIT_DOORWAY,
	KILL_PLAYER
}

var monster_state := MonsterState.PATROLLING_OUTSIDE
var move_outside_speed := 10.0
var move_inside_speed := 8.0
var current_node_index := 0
var current_inside_node_index := 0
var tween : Tween = null

func _ready():
	scary_music.stream = eraseme
	scary_music.play()
	global_position = outside_waypoints_parent.get_child(1).global_position

func _process(_delta):
	match monster_state:
		MonsterState.PATROLLING_OUTSIDE:
			patrol_outside()
		
		MonsterState.PATROLLING_INSIDE:
			patrol_inside()
		
		MonsterState.ENTER_DOORWAY:
			enter_doorway()
		
		MonsterState.EXIT_DOORWAY:
			exit_doorway()
		
		MonsterState.KILL_PLAYER:
			kill_player()

func patrol_outside():
	var next_node_index := ((current_node_index + 1) % outside_waypoints_parent.get_child_count()) # prevent it from going past bounds
	var next_node := (outside_waypoints_parent.get_child(next_node_index)) as Node3D
	if next_node.global_position.distance_to(self.global_position) < 1.0:
		var future_node_index := ((next_node_index + 1) % outside_waypoints_parent.get_child_count())
		var future_node := (outside_waypoints_parent.get_child(future_node_index)) as Node3D
		
		var rng = RandomNumberGenerator.new()
		#print(rng.randf())
		#print(current_node_index)
		if rng.randf() < 0.5 and current_node_index == 6:
		#if current_node_index == 6:
			monster_state = MonsterState.ENTER_DOORWAY
			scary_music.unit_size = 3
			scary_music.stream = erasemescary
			scary_music.playing = true
		else:
			move_monster_helper(future_node.global_position, move_outside_speed)
		current_node_index = (current_node_index + 1) % outside_waypoints_parent.get_child_count()

func patrol_inside():
	var next_node_index := ((current_inside_node_index + 1) % inside_waypoints_parent.get_child_count())
	var next_node := (inside_waypoints_parent.get_child(next_node_index)) as Node3D
	if next_node.global_position.distance_to(self.global_position) < 1.0:
		var future_node_index := ((next_node_index + 1) % inside_waypoints_parent.get_child_count())
		var future_node := (inside_waypoints_parent.get_child(future_node_index)) as Node3D
		
		var rng = RandomNumberGenerator.new()
		#print(rng.randf())
		#print(current_inside_node_index)
		if rng.randf() < 0.8 and current_inside_node_index == 5:
		#if current_inside_node_index == 5:
			monster_state = MonsterState.EXIT_DOORWAY
			scary_music.unit_size = 3
			scary_music.stream = eraseme
			scary_music.playing = true
		else:
			move_monster_helper(future_node.global_position, move_inside_speed)
		current_inside_node_index = (current_inside_node_index + 1) % inside_waypoints_parent.get_child_count()
		
	if (light_switch.light_on or monitor.computer_light.visible):
		SoundBus.scream.play()
		monster_state = MonsterState.KILL_PLAYER
		#pass
		
	#print("patrol inside")

func enter_doorway():
	move_monster_helper(inside_waypoints_parent.get_child(0).global_position, 3.0)
	
	current_inside_node_index = -1
	if global_position.distance_to(inside_waypoints_parent.get_child(0).global_position) < 1.0:
		monster_state = MonsterState.PATROLLING_INSIDE
	
	#print("enter doorway")

func exit_doorway():
	move_monster_helper(outside_waypoints_parent.get_child(7).global_position, move_inside_speed)
	
	current_node_index = -1
	if global_position.distance_to(outside_waypoints_parent.get_child(7).global_position) < 1.0:
		monster_state = MonsterState.PATROLLING_OUTSIDE
		move_monster_helper(outside_waypoints_parent.get_child(0).global_position, move_outside_speed)
	#print("exit doorway")

func kill_player():
	move_monster_helper(player_camera.global_position, move_outside_speed)
	scary_music.stop()
	current_inside_node_index = -1
	if (!light_switch.light_on and !monitor.computer_light.visible):
		monster_state = MonsterState.PATROLLING_INSIDE
	else:
		if global_position.distance_to(player_camera.global_position) < 1.0:
			get_tree().change_scene_to_packed(bsod)

func move_monster_helper(pos : Vector3, speed : float):
	if tween != null:
		tween.kill()
		tween = null
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, pos.distance_to(global_position) / speed)
	var new_rot := atan2(global_position.direction_to(pos).x, global_position.direction_to(pos).z)
	rotation = Vector3(0, new_rot + deg_to_rad(90), 0) 
