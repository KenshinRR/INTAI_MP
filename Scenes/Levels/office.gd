extends Node2D

@onready var player = $Player

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
