extends Node3D

class_name MonsterMovement

@export var monster_nav_agent: NavigationAgent3D = null
@export var hallway_parent: Node3D = null
@export var waypoints_parent: Node3D = null

@export var monster_scream: AudioStreamPlayer2D = null
@export var breathing: AudioStreamPlayer2D = null
@export var snarl: AudioStreamPlayer2D = null
@export var monster_groans: Array[AudioStreamPlayer3D] = []

@export var monster_activation_area: Area3D = null
@export var monster_spawn_point: Node3D = null
@export var monster_path_point: Node3D = null

@export var fade_to_black_control: Control = null

enum MonsterState {
	INACTIVE,
	DEMO,
	WANDERING,
	CHASING,
	GOING_TO_LAST_POSITION
}

class MonsterPathNode:
	var path_node: Node3D
	var neighbors: Array[Node3D] = []

	func _init(_path_node: Node, _neighbors: Array[Node3D]) -> void:
		path_node = _path_node as Node3D
		neighbors = _neighbors

@onready var path: Array[MonsterPathNode] = [
	MonsterPathNode.new(waypoints_parent.get_node("Node1"), [waypoints_parent.get_node("Node2") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node2"), [waypoints_parent.get_node("Node1") as Node3D, waypoints_parent.get_node("Node3") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node3"), [waypoints_parent.get_node("Node2") as Node3D, waypoints_parent.get_node("Node4") as Node3D, waypoints_parent.get_node("Node8") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node4"), [waypoints_parent.get_node("Node3") as Node3D, waypoints_parent.get_node("Node5") as Node3D, waypoints_parent.get_node("Node7") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node5"), [waypoints_parent.get_node("Node4") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node6"), [waypoints_parent.get_node("Node7") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node7"), [waypoints_parent.get_node("Node4") as Node3D, waypoints_parent.get_node("Node8") as Node3D, waypoints_parent.get_node("Node6") as Node3D]),
	MonsterPathNode.new(waypoints_parent.get_node("Node8"), [waypoints_parent.get_node("Node3") as Node3D, waypoints_parent.get_node("Node7") as Node3D]),
]

@onready var last_node: Node3D = waypoints_parent.get_node("Node8")
@onready var next_node: Node3D = waypoints_parent.get_node("Node7")

var player_killed := false

var monster_speed := 4.0
var hallway_area_count := 0
var player: PlayerController = null

var last_player_hallway_positions: Array[Vector3] = []
var closest_node_to_last_seen_position: Node3D = null

var last_player_seen_time := 0

var monster_state := MonsterState.INACTIVE

var current_breathing_tween: Tween = null
var playing_heavy_breathing := false

var last_monster_seen_time := 0

var is_groaning := false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0] as PlayerController

	last_player_hallway_positions.append(player.global_position)

	for hallway_node in hallway_parent.get_children():
		var hallway_area := hallway_node as Area3D
		hallway_area.body_entered.connect(_player_entered_hallway)
		hallway_area.body_exited.connect(_player_exited_hallway)
	
	monster_activation_area.body_entered.connect(_activated_entered)	

func _activated_entered(body: Node3D) -> void:
	if monster_state != MonsterState.INACTIVE or body != player:
		return

	monster_state = MonsterState.DEMO

	_groan_loop()

func _process(delta: float) -> void:
	if monster_state != MonsterState.INACTIVE:
		_move_towards_target_position(delta)

	if player_killed:
		_fade_to_black(delta)

func _physics_process(_delta: float) -> void:
	if is_player_in_hallway():
		last_player_hallway_positions.append(player.global_position)

		if last_player_hallway_positions.size() > 15:
			last_player_hallway_positions.pop_front()

	if has_player_in_sight() and is_player_in_hallway():
		last_player_seen_time = Time.get_ticks_msec()

	if has_player_in_sight() and not playing_heavy_breathing:
		start_heavy_breathing()
	elif Time.get_ticks_msec() - last_player_seen_time > 3000 and playing_heavy_breathing:
		stop_heavy_breathing()

	match monster_state:
		MonsterState.INACTIVE:
			pass

		MonsterState.DEMO:
			monster_nav_agent.set_target_position(monster_path_point.global_position)

			var direction_towards_path := global_position.direction_to(monster_nav_agent.get_next_path_position())
			direction_towards_path.y = 0.0
			direction_towards_path = direction_towards_path.normalized()

			var yaw := -atan2(direction_towards_path.z, direction_towards_path.x)
			global_rotation.y = yaw - PI / 2.0

			if distance_to_2d(global_position, monster_path_point.global_position) < 0.5:
				monster_state = MonsterState.WANDERING

		MonsterState.WANDERING:
			monster_nav_agent.set_target_position(next_node.global_position)

			var direction_towards_path := global_position.direction_to(monster_nav_agent.get_next_path_position())
			direction_towards_path.y = 0.0
			direction_towards_path = direction_towards_path.normalized()

			var yaw := -atan2(direction_towards_path.z, direction_towards_path.x)
			global_rotation.y = yaw - PI / 2.0

			if distance_to_2d(global_position, next_node.global_position) < 0.1:
				var new_next_node := find_next_node()
				last_node = next_node
				next_node = new_next_node

			if has_player_in_sight() and is_player_in_hallway():
				closest_node_to_last_seen_position = null
				monster_state = MonsterState.CHASING

				monster_scream.play()
				start_heavy_breathing()

		MonsterState.CHASING:
			monster_nav_agent.set_target_position(player.global_position)

			_look_at_player()
			
			if is_player_in_hallway() and not has_player_in_sight():
				var closest_distance := 50000.0
				for node in path:
					var distance := node.path_node.global_position.distance_to(last_player_hallway_positions[0])
					if distance < closest_distance:
						closest_distance = distance
						closest_node_to_last_seen_position = node.path_node

				next_node = closest_node_to_last_seen_position

				if Time.get_ticks_msec() - last_player_seen_time > 4000:
					monster_state = MonsterState.WANDERING

			if not is_player_in_hallway():
				monster_state = MonsterState.GOING_TO_LAST_POSITION

		MonsterState.GOING_TO_LAST_POSITION:
			monster_nav_agent.set_target_position(last_player_hallway_positions[0])

			_look_at_player()

			if is_player_in_hallway() and has_player_in_sight():
				monster_state = MonsterState.WANDERING # hack to play scream sound

			if Time.get_ticks_msec() - last_player_seen_time > 4000:
				monster_state = MonsterState.WANDERING

	if has_player_in_sight() and is_player_in_hallway() and distance_to_2d(position, player.position) < 1.0:
		var death_camera := get_tree().get_nodes_in_group("DeathCamera")[0] as Camera3D
		death_camera.current = true

		var crosshair := player.get_node("Crosshair") as Control
		crosshair.visible = false

		if not monster_scream.playing:
			monster_scream.play()

		monster_state = MonsterState.INACTIVE
		
		global_position = monster_spawn_point.global_position
		global_rotation = Vector3(0, 0, 0)

		player.position = (get_tree().root.get_node("Main/SpawnPoint") as Node3D).position
		player.velocity = Vector3(0, 0, 0)
		player.yaw = -PI / 2.0

		fade_to_black_control.modulate.a = 0.0
		player.process_mode = ProcessMode.PROCESS_MODE_DISABLED

		await get_tree().create_timer(2.0).timeout

		player_killed = true

func _fade_to_black(delta: float) -> void:
	fade_to_black_control.modulate.a = clampf(fade_to_black_control.modulate.a + delta, 0.0, 1.0)

	if fade_to_black_control.modulate.a == 1.0:
		fade_to_black_control.modulate.a = 0.0
		player.process_mode = ProcessMode.PROCESS_MODE_INHERIT
		player_killed = false

		var death_camera := get_tree().get_nodes_in_group("DeathCamera")[0] as Camera3D
		death_camera.current = false

		var crosshair := player.get_node("Crosshair") as Control
		crosshair.visible = true

func _look_at_player() -> void:
	var direction_to_player := global_position.direction_to(player.global_position)
	direction_to_player.y = 0.0
	direction_to_player = direction_to_player.normalized()

	var yaw := -atan2(direction_to_player.z, direction_to_player.x)
	global_rotation.y = yaw - PI / 2.0

func distance_to_2d(position1: Vector3, position2: Vector3) -> float:
	return Vector3(position1.x, 0.0, position1.z).distance_to(Vector3(position2.x, 0.0, position2.z))

func _move_towards_target_position(delta: float) -> void:
	var desired_position := monster_nav_agent.get_next_path_position()
	if global_position.distance_to(desired_position) < monster_speed * delta:
		global_position = desired_position
	else:
		global_position += global_position.direction_to(desired_position) * monster_speed * delta

func is_player_in_hallway() -> bool:
	return hallway_area_count != 0

func _player_entered_hallway(body: Node3D) -> void:
	if body != player:
		return

	hallway_area_count += 1

func _player_exited_hallway(body: Node3D) -> void:
	if body != player:
		return

	hallway_area_count -= 1

func start_heavy_breathing() -> void:
	if current_breathing_tween != null:
		return

	current_breathing_tween = get_tree().create_tween()
	current_breathing_tween.tween_method(set_breathing_volume, 0.0, 1.0, 0.4)
	current_breathing_tween.finished.connect(_finish_tween)
	playing_heavy_breathing = true

func stop_heavy_breathing() -> void:
	if current_breathing_tween != null:
		return

	current_breathing_tween = get_tree().create_tween()
	current_breathing_tween.tween_method(set_breathing_volume, 1.0, 0.0, 0.4)
	current_breathing_tween.finished.connect(_finish_tween)
	playing_heavy_breathing = false

func _finish_tween() -> void:
	current_breathing_tween = null

func set_breathing_volume(volume: float) -> void:
	breathing.volume_db = log(volume)* 8.6858896380650365530225783783321

func has_player_in_sight() -> bool:
	var space_state := get_world_3d().direct_space_state
	var raycast := PhysicsRayQueryParameters3D.create(global_position, player.global_position)
	raycast.hit_from_inside = true
	var result := space_state.intersect_ray(raycast)

	if not result.has("collider"):
		return false

	return result.get("collider") == player

func find_next_node() -> Node3D:
	var monster_path_node: MonsterPathNode = null
	for path_node in path:
		if path_node.path_node == next_node:
			monster_path_node = path_node

	if monster_path_node.neighbors.size() == 1:
		return monster_path_node.neighbors[0]

	while true:
		var random_pick: Node3D = monster_path_node.neighbors.pick_random()
		if random_pick != last_node:
			return random_pick

	return null  # unreachable

func _groan_loop() -> void:
	if is_groaning:
		return

	is_groaning = true

	var rng := RandomNumberGenerator.new()

	while monster_state != MonsterState.INACTIVE:
		var random_groan := rng.randi_range(0, monster_groans.size() - 1)
		monster_groans[random_groan].play()

		await get_tree().create_timer(monster_groans[random_groan].stream.get_length()).timeout

		var random_amount := rng.randf_range(2.0, 5.0)
		await get_tree().create_timer(random_amount).timeout
