extends Node2D

@onready var BulletManager = $BulletManager
@onready var player = $Agents/Player

func _ready():
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
