extends Node2D

@onready var power_up_scene = preload("res://Scenes/Power Ups/power_up.tscn")
var tile_map
var astar_grid

@onready var timer = $Timer

var power_up
var powere_up_position: Vector2

var is_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#setting up the variables
	tile_map = get_tree().get_first_node_in_group("Map")
	
	#preparing the A* tilemap
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar_grid.update()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_spawned:
		timer.wait_time = randi_range(15,20)
		is_spawned = false
	pass

func _free_slot():
	
	
	pass

func _on_timer_timeout():
	is_spawned = true
	var valid = false
	var region_size = astar_grid.region.size
	var generated_pos : Vector2
	
	power_up = power_up_scene.instantiate()
	get_tree().root.add_child(power_up)
	
	while(!valid):
		generated_pos.x = randi_range(0,region_size.x)
		generated_pos.y = randi_range(0,region_size.y)
		var tileData = tile_map.get_cell_tile_data(0, generated_pos)
		if tileData == null:
			continue
		if not tileData.get_custom_data("Walkable"):
			valid = false;
			continue
		tileData = tile_map.get_cell_tile_data(1, generated_pos)
		if tileData != null:
			valid = false
			continue
		valid = true
		
	power_up.global_position = tile_map.map_to_local(generated_pos)
	
	pass # Replace with function body.
