extends Node2D

signal start_game



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("enemies", "queue_free")
	$MapSelector.hide()
	$MapSelector.back.connect(title)
	ScoreManager.resetValues()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func title():
	$ColorRect.show()
	$MapSelector.hide()

func _on_button_pressed():
	$ColorRect.hide()
	$MapSelector.show()


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
