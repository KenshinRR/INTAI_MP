extends CharacterBody2D

signal bulletShoot(bullet, position, direction)
signal invi

@onready var vision_pro_max = $"Vision ProMax"
@onready var weapon = $Weapon
@onready var health = $Health
var player
var isMoving = false
var MovementSpeed = 100
var targetPosition = Vector2.ZERO
var isDead = false
var time_since_died = 0
var respawn_time = 5
var deadLocation
var FirstSpawn = true
var Spawner : int
var SpawnLocation

var shootDelay = 1.5  #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0

var AStarGrid: AStarGrid2D
var tile_map
var watchpoint

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		isDead = true
		ScoreManager.player_kills += 1

func _ready():
	if FirstSpawn:
		Spawner = randi_range(0,2)
		FirstSpawn = false
	
	SpawnLocation = get_tree().get_nodes_in_group("Enemy Spawns")[Spawner]
	deadLocation = get_tree().get_nodes_in_group("Respawn Locations")[1]
	player = get_tree().get_first_node_in_group("Player")
	tile_map = get_tree().get_first_node_in_group("Map")
	watchpoint = get_tree().get_first_node_in_group("Watchpoint")
	
	weapon.weaponFired.connect(self.shootBullet)
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
	look_at(player.global_position)
	time_since_last_shot += _delta
	vision_pro_max.target_position = to_local(player.position)
	checkPlayerVisible()
	
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
	
func checkPlayerVisible():
	if vision_pro_max.get_collider() == player and time_since_last_shot >= shootDelay:
		weapon.shootBullet()
		time_since_last_shot = 0

		
func shootBullet(bullet_instance, location, direction):
	emit_signal("bulletShoot", bullet_instance, location, direction)
	
func move():
	var path = AStarGrid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
	)
	
	path.pop_front()
	
	if path.size() == 1 or path.is_empty():
		targetPosition = watchpoint.global_position
	else:
		targetPosition = tile_map.map_to_local(path[0])
	
	isMoving = true
	
func _physics_process(_delta):
	if isMoving:
		var direction = targetPosition - global_position
		velocity = (direction * MovementSpeed) * _delta
		move_and_slide()

	else:
		velocity = Vector2.ZERO
	
	isMoving = false
	
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
