extends Node2D

@onready var player = $Player
@onready var bullet_manager = $BulletManager

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
