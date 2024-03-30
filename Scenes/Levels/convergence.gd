extends Node2D



@onready var player = $Player

@onready var bullet_manager = "res://Scenes/Bullet/BulletManager.gd"
@export var power_up_scene: PackedScene
var timer
var enemyList

func _ready():
	check()
	$PrepTimer.start()
	#connecting player to bullet manager
	player.bulletShoot.connect(BulletManager.handleBulletSpawn)
	
	#connecting enemies to bullet manager
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.bulletShoot.connect(BulletManager.handleBulletSpawn)
	
	#set up to SEE nodes
	$Timer.timeUp.connect(end)
	
	#defensive_ai.bulletShoot.connect(BulletManager.handleBulletSpawn)
func check():
	enemyList = get_tree().get_nodes_in_group("enemies")
	match ScoreManager.bot_index:
		0:
			var enemyScene = preload("res://Scenes/Enemies/Offensive Enemy/Offensive Enemy.tscn")
			var enemy = enemyScene.instantiate()
			self.add_child(enemy)
		1:
			var enemyScene = preload("res://Scenes/Enemies/Defensive Enemy/Defensive Enemy.tscn")
			var enemy = enemyScene.instantiate()
			self.add_child(enemy)
		2:
			var enemyScene = preload("res://Scenes/Enemies/Smart Enemy/smart_enemy.tscn")
			var enemy = enemyScene.instantiate()
			self.add_child(enemy)
	
	
func _process(delta):
	if ScoreManager.player_score >= 3:
		end()
	elif ScoreManager.enemy_score >= 3:
		
		end()
	pass
func end():
	get_tree().call_group("mobs", "queue_free")
	get_tree().change_scene_to_file("res://Scenes/UI/game_end_screen.tscn")
	
func _on_prep_timer_timeout():
	$Message.hide()
	$MessageBox.hide()
	pass # Replace with function body.
