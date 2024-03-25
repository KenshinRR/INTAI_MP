extends Node2D

@onready var player = $Player
@onready var bullet_manager = "res://Scenes/Bullet/BulletManager.gd"

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
