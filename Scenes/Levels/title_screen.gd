extends Node2D

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreManager.resetValues()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	$ColorRect.hide()
	$Message.hide()
	$Button.hide()
	
	get_tree().change_scene_to_file("res://Scenes/Levels/office.tscn")