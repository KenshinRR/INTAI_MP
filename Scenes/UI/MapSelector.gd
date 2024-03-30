extends Control


signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_start_button_pressed():
	match ScoreManager.map_index:
		0:
			get_tree().change_scene_to_file("res://Scenes/Levels/office.tscn")
		1:
			get_tree().change_scene_to_file("res://Scenes/Levels/desert.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/Levels/convergence.tscn")
			
	pass # Replace with function body.


func _on_botted_item_selected(index):
	ScoreManager.bot_index = index
	pass # Replace with function body.


func _on_mapped_item_selected(index):
	
	ScoreManager.map_index = index
	pass # Replace with function body.


func _on_back_button_pressed():
	emit_signal("back")
	pass # Replace with function body.
