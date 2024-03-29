extends Node

var player_score = 0
var enemy_score = 0

var player_kills = 0
var enemy_kills = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#func handleWin():
	#get_tree().change_scene_to_file("res://Scenes/Levels/title_screen.tscn")

func resetValues():
	player_score = 0
	enemy_score = 0
	player_kills = 0
	enemy_kills = 0
