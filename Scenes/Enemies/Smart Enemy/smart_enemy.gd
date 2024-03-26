extends CharacterBody2D

#pathfinding
@onready var tile_map = $"../Map"
var astar_grid: AStarGrid2D
@onready var player = $"../Player"

#movement
var is_moving = false
var MovementSpeed = 100
var target_position = Vector2.ZERO

#heath
@onready var health = $Health
var spawn = false

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		queue_free()
		spawn = true

func _ready():
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
	if is_moving:
		return
		
	move()
	
func move():
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
	)
	
	path.pop_front()
	
	if path.is_empty():
		print("No path")
		return
		
	#var original_position = Vector2(global_position)
	
	#global_position = tile_map.map_to_local(path[0])
	#global_position.move_toward(tile_map.map_to_local(path[0]), 1)
	
	target_position = tile_map.map_to_local(path[0])
	
	#velocity = path[0].direction * MovementSpeed
	
	is_moving = true
	
func _physics_process(delta):
	var direction = target_position - global_position
	#global_position.move_toward(target_position, MovementSpeed * delta)
	velocity = direction * MovementSpeed * delta
	move_and_slide()
	is_moving = false

func _on_timer_timeout():
	pass # Replace with function body.
