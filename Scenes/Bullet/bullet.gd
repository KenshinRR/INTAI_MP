extends Area2D

@export var speed = 200

var direction = Vector2.ZERO
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		global_position += velocity
		
func setDirection(bullet_direction):
		self.direction = bullet_direction
		rotation += direction.angle()

func _on_display_timer_timeout():
	queue_free()

func _on_body_entered(_body):
	queue_free() 

func _on_area_entered(_area):
	queue_free() 
