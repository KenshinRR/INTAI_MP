extends Node2D

func handleBulletSpawn(bullet, position, direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.setDirection(direction)
