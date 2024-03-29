extends CharacterBody2D

#aiming and shooting
@onready var raycast = $LineOfSight
var time_since_last_shot = 0
var shootDelay = 1.5 
@onready var weapon = $Weapon
signal bulletShoot(bullet, position, direction)

#pathfinding
var tile_map
var astar_grid: AStarGrid2D
var player
var watchpoint
var base_target : Array

#movement
var is_moving = false
var MovementSpeed = 100
var target_position = Vector2.ZERO
var prepTimer
var roundStart = false
var powerUp_locs : Array

#heath
@onready var health = $Health
var isDead = false
var time_since_died = 0
var respawn_time = 5
var deadLocation
var FirstSpawn = true
var Spawner : int
var SpawnLocation

#powerup
signal invi
signal scram(owner)

func _ready():
	#setting up the variables
	if FirstSpawn:
		Spawner = randi_range(0,2)
		FirstSpawn = false
	
	SpawnLocation = get_tree().get_nodes_in_group("Enemy Spawns")[Spawner]
	base_target = get_tree().get_nodes_in_group("Player Bases")
	watchpoint = get_tree().get_first_node_in_group("Watchpoint")
	player = get_tree().get_first_node_in_group("Player")
	tile_map = get_tree().get_first_node_in_group("Map")
	deadLocation = get_tree().get_nodes_in_group("Respawn Locations")[1]
	prepTimer = get_tree().get_first_node_in_group("PrepTimer")
	
	global_position = SpawnLocation.global_position
	#shooting
	weapon.weaponFired.connect(self.shootBullet)
	
	#preparing the A* tilemap
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var regional_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + regional_position.x,
				y + regional_position.y
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or not tile_data.get_custom_data("Walkable"):
				astar_grid.set_point_solid(tile_position)
				
			tile_data = tile_map.get_cell_tile_data(1, tile_position)
			
			if tile_data == null:
				continue
				
			if not tile_data.get_custom_data("Walkable"):
				astar_grid.set_point_solid(tile_position)
				
				
func _process(_delta):
	raycast.target_position = to_local(player.global_position)
	look_at(player.global_position)
	if is_moving:
		return
		
	if isDead:
		handle_death()
	else:
		move()
		
	if isDead:
		time_since_died += _delta
	
	if isDead and time_since_died >= respawn_time:
		handle_respawn()

func _physics_process(delta):
	if not roundStart:
		await prepTimer.timeout
		roundStart = true
		
	#movement
	var direction = target_position - global_position
	velocity = direction * MovementSpeed * delta
	move_and_slide()
	is_moving = false
	#shooting
	if !player.isDead:
		isShooting(delta)

func _on_timer_timeout():
	pass # Replace with function body.

func move():
	#looking for power ups
	_updateGridValues()
	
	#deciding where to go
	var player_tile_data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(player.global_position))
	
	var target
	#setting target position
	if player.isDead == true && _getAvailableBase() != null:
		target = _getAvailableBase().global_position
	
	if player.isDead == false:
		if player_tile_data.get_custom_data("Enemy Base"):
			target = watchpoint.global_position
		else:
			target = player.global_position
			
	if target == null: #if target is still null somehow
		target = watchpoint.global_position #go back to base
		
	#getting path
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(target)
	)
	
	resetGridValues()
	
	path.pop_front()
	
	if path.is_empty():
		#print("No path")
		return
	
	target_position = tile_map.map_to_local(path[0])
	
	is_moving = true

func _updateGridValues():
		
	var power_ups = get_tree().get_nodes_in_group("power_ups")
	
	if power_ups.is_empty():
		return
	
	for power_up in power_ups:
		var locPos = tile_map.local_to_map(power_up.global_position)
		#print("PowerUp at: ", locPos)
		match power_up.rando:
			1:
				#print("Found good one")
				astar_grid.set_point_weight_scale(locPos, 10)
			_:
				#print("Found non desirable")
				astar_grid.set_point_solid(locPos)
			
		powerUp_locs.append(locPos)
	
	pass
	
func resetGridValues():
	for powerUp in powerUp_locs:
		astar_grid.set_point_weight_scale(powerUp, 0)
		astar_grid.set_point_solid(powerUp, false)
		
	powerUp_locs.clear()
	pass

func isShooting(_delta):
	if !raycast.is_colliding():
		time_since_last_shot += _delta
		if time_since_last_shot >= shootDelay:	#makes sure to not shoot bullets instantly
			weapon.shootBullet()
			time_since_last_shot = 0
			
func shootBullet(bullet_instance, location, direction):
	emit_signal("bulletShoot", bullet_instance, location, direction)

func _getAvailableBase():
	#getting the available bases
	var base_target_buffer : Array
	for target in base_target:
		if !target.is_destroyed:
			base_target_buffer.append(target)
	
	if base_target_buffer.is_empty():
		return
	
	#initialize distance to target
	var targetDistance = global_position.distance_to(base_target_buffer[0].global_position)
	targetDistance = int(targetDistance)
	var currentDistance #buffer for the distance of the current target
	var targetSpotted# = base_target[0]#the target value to return
	
	for target in base_target_buffer:
		currentDistance = global_position.distance_to(target.global_position)
		currentDistance = int(currentDistance)
		if targetDistance >= currentDistance:
			targetDistance = currentDistance
			targetSpotted = target
				
	return targetSpotted 

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		ScoreManager.player_kills += 1
		isDead = true

func handle_respawn():
	global_position = SpawnLocation.global_position
	isDead = false
	health.health = 10
	time_since_died = 0
	
func handle_death():
	global_position = deadLocation.global_position
	pass
	
func power_handle(rando):
	if rando == 0:
		emit_signal("scram", "Enemy")
		print("chaos")
	if rando == 1:
		emit_signal("invi")
	
	if rando == 2:
		health.health = 0
		isDead = true
		print("mines")
