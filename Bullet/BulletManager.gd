extends Node2D

func handleBulletSpawn(bullet, pos, direction):
	add_child(bullet)
	bullet.global_position = pos
	bullet.setDirection(direction)
