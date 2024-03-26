extends Node2D

@onready var player = $Player
@onready var enemy = $"Enemy/Smart Enemy"
@onready var bullet_manager = "res://Scenes/Bullet/BulletManager.gd"

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
	enemy.bulletShoot.connect(BulletManager.handleBulletSpawn)
