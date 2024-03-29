extends Control

signal gone


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			
	pass


func _on_button_pressed():
	emit_signal("gone")
	pass # Replace with function body.
