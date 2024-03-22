extends Node2D

func handleBulletSpawn(bullet, bullet_position, direction):
	add_child(bullet)
	bullet.global_position = bullet_position
	bullet.setDirection(direction)
