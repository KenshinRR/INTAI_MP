extends CharacterBody2D

@onready var health = $Health

func handle_hit():
	health.health -= 10
	if health.health <= 0:
		queue_free()
