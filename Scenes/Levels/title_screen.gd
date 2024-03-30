extends Node2D

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$MapSelector.hide()
	
	ScoreManager.resetValues()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	$ColorRect.hide()
	$MapSelector.show()


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
