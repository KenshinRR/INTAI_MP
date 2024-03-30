extends Area2D

@export var base_owner: String
@onready var sprite = $AnimatedSprite2D
var is_destroyed = false
var is_destroyable = true

var tile_map
var astar_grid

var player
var enemyList

# Called when the node enters the scene tree for the first time.
func _ready():
	#assigning sprite
	if base_owner == "Player":
		sprite.play("PlayerBaseIdle")
	elif base_owner == "Enemy":
		sprite.play("EnemyBaseIdle")
	
	#setting up the variables
	tile_map = get_tree().get_first_node_in_group("Map")
	player = get_tree().get_first_node_in_group("Player")
	enemyList = get_tree().get_nodes_in_group("enemies")
	
	#setting up player signals
	player.scram.connect(self._on_scram)
	player.invi.connect(self._invi)
	
	#setting up enemy signals
	for enemy in enemyList:
		enemy.scram.connect(self._on_scram)
		enemy.invi.connect(self._invi)
	
	#preparing the A* tilemap
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar_grid.update()
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.has_overlapping_bodies():
		var overlaps = get_overlapping_bodies()
		for overlap in overlaps:
			_on_body_entered(overlap)
			
	pass


func _on_body_entered(body):
	
	if(base_owner == "Enemy" && 
	body.name == "Player"
	&& !is_destroyed && is_destroyable):
		ScoreManager.player_score+= 1
		is_destroyed = true
		sprite.play("EnemyBaseDestroyed")
	elif (base_owner == "Player" && 
	body.is_in_group("enemies")
	&& !is_destroyed && is_destroyable):
		sprite.play("PlayerBaseDestroyed")
		ScoreManager.enemy_score+= 1
		is_destroyed = true
	pass # Replace with function body.


func _on_invul_timer_timeout():
	is_destroyable = true;
	print("Base destroyable")
	
	
func _invi(owner):
	if(owner == "Player" && self.base_owner== "Player"):
		$InvulTimer.start()
		is_destroyable = false;
		print("Base not destroyable")
	if(owner == "Enemy" && self.base_owner == "Enemy"):
		$InvulTimer.start()
		is_destroyable = false;
		print("Base not destroyable")



func _on_scram(owner):
	#if not same owner
	if owner != base_owner:
		return
		
	var valid = false
	var region_size = astar_grid.region.size
	var generated_pos = Vector2(0,0)
	
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
		if isOnPowerUp(generated_pos):
			valid = false
			continue
		if isOnBase(generated_pos):
			valid = false
			continue
		valid = true
		if !is_destroyed:
			self.global_position = tile_map.map_to_local(generated_pos)
	
func isOnPowerUp(currentPos):
	currentPos = Vector2i(currentPos)
	var valid = false
	var power_ups = get_tree().get_nodes_in_group("power_ups")
	for power_up in power_ups:
		var loc = tile_map.local_to_map(power_up.global_position)
		if currentPos == loc:
			valid = true
	pass

func isOnBase(currentPos):
	currentPos = Vector2i(currentPos)
	var valid = false
	var bases = get_tree().get_nodes_in_group("bases")
	for base in bases:
		var loc = tile_map.local_to_map(base.global_position)
		if currentPos == loc:
			valid = true
	pass
