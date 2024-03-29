extends Control

signal timeUp
var time = 10
var mins 
var secs


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	secs = time % 60
	mins = time / 60
	$Time.text = "Time Left: " + str(mins) + ":" + str(secs)
	if time <= 0 :
		emit_signal("timeUp")
	
	pass


func _on_ingame_time_timeout():
	if time > 0:
		time -= 1
	pass # Replace with function body.
