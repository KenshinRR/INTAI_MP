extends Area2D

@export var speed = 500

var direction = Vector2.ZERO
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		global_position += velocity
		
func setDirection(bullet_direction):
		self.direction = bullet_direction
		rotation += bullet_direction.angle()

func _on_display_timer_timeout():
	queue_free() 

func _on_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free() 

func _on_area_entered(_area):
	queue_free() 
