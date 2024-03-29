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

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		ScoreManager.player_kills += 1
		isDead = true

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
	
	global_position = SpawnLocation.global_position
	#shooting
	weapon.weaponFired.connect(self.shootBullet)
	
	#preparing the A* tilemap
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
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
	
	
func move():
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
	
	#getting path
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(target)
	)
	
	path.pop_front()
	
	if path.is_empty():
		#print("No path")
		return
	
	target_position = tile_map.map_to_local(path[0])
	
	is_moving = true

func _physics_process(delta):
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

func isShooting(_delta):
	if !raycast.is_colliding():
		time_since_last_shot += _delta
		if time_since_last_shot >= shootDelay:	#makes sure to not shoot bullets instantly
			weapon.shootBullet()
			time_since_last_shot = 0
			
func shootBullet(bullet_instance, location, direction):
	emit_signal("bulletShoot", bullet_instance, location, direction)

func _getAvailableBase():
	for target in base_target:
		if !target.is_destroyed:
			return target

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
		print("chaos")
	if rando == 1:
		emit_signal("invi")
	
	if rando == 2:
		health.health = 0
		isDead = true
		print("mines")
