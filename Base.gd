extends Area2D

@export var base_owner: String
@onready var sprite = $AnimatedSprite2D
var is_destroyed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if base_owner == "Player":
		sprite.play("PlayerBaseIdle")
	elif base_owner == "Enemy":
		sprite.play("EnemyBaseIdle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if(base_owner == "Enemy" && 
	body.name == "Player"
	&& !is_destroyed):
		ScoreManager.player_score+= 1
		is_destroyed = true
		sprite.play("EnemyBaseDestroyed")
	elif (base_owner == "Player" && 
	body.is_in_group("enemies")
	&& !is_destroyed):
		sprite.play("PlayerBaseDestroyed")
		ScoreManager.enemy_score+= 1
		is_destroyed = true
	pass # Replace with function body.
