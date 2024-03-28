extends Node2D

@onready var player = $Player
@onready var enemy = $"Enemy/Smart Enemy"
@onready var bullet_manager = "res://Scenes/Bullet/BulletManager.gd"
@export var power_up_scene: PackedScene

func _ready():
	$PrepTimer.start()
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
	enemy.bulletShoot.connect(BulletManager.handleBulletSpawn)


func _on_prep_timer_timeout():
	$Message.hide()
	$MessageBox.hide()
	pass # Replace with function body.
