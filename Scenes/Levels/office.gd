extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Player

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)