extends CharacterBody2D
@export var MovementSpeed = 3000.0
@export var startDirection = Vector2(0,1)
#@export var Bullet : PackedScene
var Bullet = preload("res://Scenes/Bullet/bullet.tscn")

#@onready var animation_tree = $AnimationTree
@onready var gunPoint = $GunPoint
@onready var gunDirec = $GunDirection

signal bulletShoot(bullet, position, direction)

var mousePosition = null
var onHold = false

var shootDelay = 0.1		 #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0

#func _ready(): #sets the initial direction the sprite is facing
	#_updateDirection(startDirection)

func _physics_process(_delta): #handles movement
	var direction = Vector2(Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left"),
	 		Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")).normalized()
	
	if(Input.get_action_strength("Shift")):
		velocity = (direction * (MovementSpeed + 300) * _delta) 
	else: 
		velocity = (direction * MovementSpeed * _delta)	
		
	move_and_slide()
	
func _process(_delta):  #mouse events
	mousePosition = get_global_mouse_position()
	isShooting(_delta)
	
	look_at(mousePosition)
	
func isShooting(_delta):
	if onHold:
		time_since_last_shot += _delta
		if time_since_last_shot >= shootDelay:	#makes sure to not shoot bullets instantly
			shootBullet()
			time_since_last_shot = 0
		
func _unhandled_input(event):
	if event.is_action_pressed("MouseLeft"):
		onHold = true
	if event.is_action_released("MouseLeft"):
		onHold = false

func shootBullet():
	var bullet_instance = Bullet.instantiate() 
	var direction = gunDirec.global_position - gunPoint.global_position
	emit_signal("bulletShoot", bullet_instance, gunPoint.global_position, direction)
		
	
#func _updateDirection(moveInput : Vector2): #updates the direction of the sprite
	#if(moveInput != Vector2.ZERO):
		#animation_tree.set("parameters/Walking/blend_position", moveInput)
