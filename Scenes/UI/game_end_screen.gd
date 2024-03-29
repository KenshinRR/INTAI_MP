extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	#3 BASE KILL
	if ScoreManager.player_score >=3:
		$ColorRect/GameOverMessage.text = "Player Wins, Bases DESTROYED"
	elif ScoreManager.enemy_score >=3:
		$ColorRect/GameOverMessage.text = "Enemy Wins, Bases DESTROYED"
		
	#TIME UP CHECK BASE KILL	
	elif ScoreManager.player_score > ScoreManager.enemy_score :
		$ColorRect/GameOverMessage.text = "Player Wins, More Bases!"
	elif ScoreManager.player_score < ScoreManager.enemy_score :
		$ColorRect/GameOverMessage.text = "Enemy Wins, More Bases!"	
		
	#BASE KILL EQUAL CHECK KILL LEADER	
	elif ScoreManager.player_kills > ScoreManager.enemy_score :
		$ColorRect/GameOverMessage.text = "Player Wins, BLOODTHIRSTY!"	
	elif ScoreManager.player_score < ScoreManager.enemy_score :
		$ColorRect/GameOverMessage.text = "Enemy Wins, BLOODTHIRSTY!"	
		
		
	else:
		$ColorRect/GameOverMessage.text = "DRAW!"	
	
	
	$ColorRect/ColorRect/Kills.text = "Kills: " + str(ScoreManager.player_kills)
	$ColorRect/ColorRect/PBases.text = "Bases Remaining: " +  str(3 - ScoreManager.enemy_score)
	
	$ColorRect/ColorRect2/BKills.text = "Kills: " + str(ScoreManager.enemy_kills)
	$ColorRect/ColorRect2/BBases.text = "Bases Remaining: " + str(3 - ScoreManager.player_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/title_screen.tscn")
	pass # Replace with function body.
