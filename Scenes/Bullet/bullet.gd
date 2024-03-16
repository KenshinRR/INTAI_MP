extends Area2D

@export var speed = 5000

var direction = Vector2.ZERO
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		global_position += velocity
		
func setDirection(direction_param):
		self.direction = direction_param
		rotation += direction.angle()


func _on_display_timer_timeout():
	queue_free() 

#func _on_body_entered(body):
	#if body.has_method("handled_hit"):
		#body.handle_hit()
		#queue_free() 


func _on_area_entered(_area):
	queue_free() 
