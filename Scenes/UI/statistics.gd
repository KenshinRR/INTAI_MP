extends Control

var player
var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/Respawning.hide()
	$ColorRect/Reloading.hide()
	$ColorRect/Invi.hide()
	
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("enemies")
	player.died.connect(_died)
	player.reload.connect(_reload)
	player.invi.connect(_invi)
	enemy.invi.connect(_invi)

func _setText():
	#check who's stats it is
	if self.name == "StatisticsPlayer":
		# change accordingly
		$ColorRect/Kills.text = "Kills: " + str(ScoreManager.player_kills)
		$ColorRect/Bases.text = "Bases Left: " + str(3 - ScoreManager.enemy_score)
		$ColorRect/Score.text = "Score: " + str(ScoreManager.player_kills + ScoreManager.player_score)
		
		
	if self.name == "StatisticsBot":
		# change accordingly
		$ColorRect/Kills.text = "Kills: " + str(ScoreManager.enemy_kills)
		$ColorRect/Bases.text = "Bases Left: " + str(3 - ScoreManager.player_score)
		$ColorRect/Score.text = "Score: " + str(ScoreManager.enemy_kills + ScoreManager.enemy_score)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_setText()
	pass



	
func _reload(owner):
	if(owner == "Player" && self.name == "StatisticsPlayer"):
		$ReloadTimer.start()
		$ColorRect/Reloading.show()
	if(owner == "Enemy" && self.name == "StatisticsBot"):
		$ReloadTimer.start()
		$ColorRect/Reloading.show()
		
func _died(owner):
	if(owner == "Player" && self.name == "StatisticsPlayer"):
		$ColorRect/Respawning.show()
		$RespawnTimer.start()
	if(owner == "Enemy" && self.name == "StatisticsBot"):
		$ColorRect/Respawning.show()
		$RespawnTimer.start()
	
func _invi(owner):
	if(owner == "Player" && self.name == "StatisticsPlayer"):
		$ColorRect/Invi.show()
		$InviTimer.start()
	if(owner == "Enemy" && self.name == "StatisticsBot"):
		$ColorRect/Invi.show()
		$InviTimer.start()
	
func _on_reload_timer_timeout():
	$ColorRect/Reloading.hide()


func _on_respawn_timer_timeout():
	$ColorRect/Respawning.hide()


func _on_invi_timer_timeout():
	$ColorRect/Invi.hide()
	pass # Replace with function body.
