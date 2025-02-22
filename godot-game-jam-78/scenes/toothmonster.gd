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

@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var last_node : Node3D = outside_waypoints_parent.get_node("Node8")

enum MonsterState {
	PATROLLING_OUTSIDE,
	PATROLLING_INSIDE,
	ENTER_DOORWAY,
	KILL_PLAYER
}

var monster_state := MonsterState.PATROLLING_OUTSIDE

func _ready():
	audio_stream_player_3d.play()
	#navigation_agent_3d.target_position = Vector3(0, global_position.y, 0)

func _process(delta):
	match monster_state:
		MonsterState.PATROLLING_OUTSIDE:
			patrol_outside()
		
		MonsterState.PATROLLING_INSIDE:
			pass
		
		MonsterState.ENTER_DOORWAY:
			pass
		
		MonsterState.KILL_PLAYER:
			pass

func patrol_outside():
	## move to each waypoint, then do below logic
	var rng = RandomNumberGenerator.new()
	if rng.randf() < 0.5 and last_node:
		monster_state = MonsterState.ENTER_DOORWAY
	print("patrol outside")

func patrol_inside():
	
	print("patrol inside")

func enter_doorway():
	
	if (light_switch.light_on or monitor.computer_light.visible):
		## move to first inside node? idk
		monster_state = MonsterState.PATROLLING_INSIDE
	print("enter doorway")

func kill_player():
	print("kill player")
