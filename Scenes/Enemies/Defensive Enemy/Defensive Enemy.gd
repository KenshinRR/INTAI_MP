extends CharacterBody2D

signal bulletShoot(bullet, position, direction)

@onready var health = $Health
var player
var vision_pro_max
var isMoving = false
var MovementSpeed = 50
var targetPosition = Vector2.ZERO
var isDead = false
var time_since_died = 0
var respawn_time = 5
var deadLocation
var FirstSpawn = false
var Spawner : int
var SpawnLocation

var shootDelay = 1.5  #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0

var AStarGrid: AStarGrid2D
var tile_map

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		isDead = true
		

func _ready():
	if FirstSpawn:
		Spawner = randi_range(0,2)
		FirstSpawn = false
	
	SpawnLocation = get_tree().get_nodes_in_group("Enemy Spawns")[Spawner]
	print(get_tree().get_nodes_in_group("Spawn Locations").size())
	deadLocation = get_tree().get_nodes_in_group("Respawn Locations")[1]
	player = get_tree().get_first_node_in_group("Player")
	vision_pro_max = get_tree().get_first_node_in_group("Vision ProMax")
	tile_map = get_tree().get_first_node_in_group("Map")
	
	global_position = SpawnLocation.global_position
	
	AStarGrid = AStarGrid2D.new()
	AStarGrid.region = tile_map.get_used_rect()
	AStarGrid.cell_size = Vector2(16,16)
	AStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	AStarGrid.update()
	
	var regionSize = AStarGrid.region.size
	var regionPosition = AStarGrid.region.position
	
	for x in regionSize.x:
		for y in regionSize.y:
			var tile_position = Vector2i(
				x + regionPosition.x,
				y + regionPosition.y
			)
			
			var tileData = tile_map.get_cell_tile_data(0, tile_position)
			
			if tileData == null or not tileData.get_custom_data("Enemy Base"):
				AStarGrid.set_point_solid(tile_position)
			
			tileData = tile_map.get_cell_tile_data(1, tile_position)
			
			if tileData == null:
				continue
				
			if not tileData.get_custom_data("Enemy Base"):
				AStarGrid.set_point_solid(tile_position)
				
func _process(_delta):
	
	
	if isMoving:
		return	
	if isDead:
		handle_death()
	else:
		if !player.isDead:
			move()
		
	if isDead:
		time_since_died += _delta
	
	if isDead and time_since_died >= respawn_time:
		handle_respawn()
	

	
func move():
	var path = AStarGrid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
	)
	
	path.pop_front()
	
	if path.size() == 1 or path.is_empty():
		return
	
	targetPosition = tile_map.map_to_local(path[0])
	
	isMoving = true
	
func _physics_process(_delta):
	if isMoving:
		var direction = targetPosition - global_position
		velocity = (direction.normalized() * MovementSpeed)
		move_and_slide()

	else:
		velocity = Vector2.ZERO
	
	isMoving = false
	
func handle_respawn():
	global_position = SpawnLocation.global_position
	isDead = false
	time_since_died = 0
	
func handle_death():
	global_position = deadLocation.global_position
	pass

