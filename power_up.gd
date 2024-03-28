extends Node2D

signal caught(rando)
var rando 



# Called when the node enters the scene tree for the first time.
func _ready():
	var power_up_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	rando = randi() % power_up_types.size()
	$AnimatedSprite2D.play(power_up_types[rando])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if body.has_method("power_handle"):
			body.power_handle(rando)
		queue_free()
		
		
	
