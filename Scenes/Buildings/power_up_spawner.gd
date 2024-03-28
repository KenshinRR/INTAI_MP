extends Node2D

@onready var power_up_scene = preload("res://Scenes/Power Ups/power_up.tscn")
@onready var tile_map = $"../../Map"


var power_up
var powere_up_position: Vector2

var is_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _free_slot():
	
	
	pass

func _on_timer_timeout():
	var valid = false
	power_up = power_up_scene.instantiate()
	get_tree().root.add_child(power_up)
	
	#while(!valid):
	power_up.global_position.x = randf_range(52,252)
	power_up.global_position.y = randf_range(44,204)
	#	var tileData = tile_map.get_cell_tile_data(0, power_up.global_position)
	#	if tileData == null or not tileData.get_custom_data("Enemy Base"):
	#		valid = false;
	#		continue
	#	tileData = tile_map.get_cell_tile_data(1, power_up.global_position)
	#	if tileData == null or not tileData.get_custom_data("Enemy Base"):
	#		valid = false
	#		continue
	#	valid = true
			
		
	
		
	pass # Replace with function body.
