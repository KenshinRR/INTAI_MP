extends Node2D

@onready var power_up_scene = preload("res://Scenes/Power Ups/power_up.tscn")

var power_up
var powere_up_position: Vector2

var is_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _free_slot():
	is_spawned = false
	$Timer.start()
	pass

func _on_timer_timeout():
	if !is_spawned:
		power_up = power_up_scene.instantiate()
		get_tree().root.add_child(power_up)
		power_up.global_position = position
		power_up.caught.connect(_free_slot)
		is_spawned = true
	pass # Replace with function body.
