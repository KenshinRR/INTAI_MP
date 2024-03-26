extends CharacterBody2D

@onready var health = $Health
var spawn = false

@onready var sprite_2d = $Sprite2D
@onready var player = $"../Player"
var isMoving = false
var MovementSpeed = 50
var targetPosition = Vector2.ZERO

@onready var tile_map = $"../Map"
var AStarGrid: AStarGrid2D

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		queue_free()
		spawn = true

func _ready():
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
		
	move()
	
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

