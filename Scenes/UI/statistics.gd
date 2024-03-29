extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/Respawning.hide()
	$ColorRect/Reloading.hide()

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
func _process(delta):
	_setText()
	pass


func _on_player_reload():
	$ReloadTimer.start()
	$ColorRect/Reloading.show()
	pass # Replace with function body.


func _on_reload_timer_timeout():
	$ColorRect/Reloading.hide()


func _on_respawn_timer_timeout():
	$ColorRect/Respawning.hide()


func _on_player_died():
	
	
	$ColorRect/Respawning.show()
	$RespawnTimer.start()
	
