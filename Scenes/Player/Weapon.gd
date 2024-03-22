extends Node2D

signal weaponFired(bullet, location, distance)

@export var Bullet : PackedScene

@onready var gunPoint = $GunPoint
@onready var gunDirec = $GunDirection

func shootBullet():
	var bullet_instance = Bullet.instantiate() 
	var direction = gunDirec.global_position - gunPoint.global_position
	emit_signal("weaponFired", bullet_instance, gunPoint.global_position, direction)
