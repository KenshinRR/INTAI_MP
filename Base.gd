extends Area2D

@export var base_owner: String
var is_destroyed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if(base_owner == "Enemy" && 
	body.name == "Player" 
	&& !is_destroyed):
		GameVariables.player_score+= 1
		is_destroyed = true
	elif (base_owner == "Player" && 
	body.name == "Enemy" 
	&& !is_destroyed):
		GameVariables.enemy_score+= 1
		is_destroyed = true
	pass # Replace with function body.
