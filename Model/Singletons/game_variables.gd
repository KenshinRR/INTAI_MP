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
	if player_score >= 3:
		print("Player Wins!")
	pass
