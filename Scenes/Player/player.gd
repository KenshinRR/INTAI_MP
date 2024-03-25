extends CharacterBody2D
@export var MovementSpeed = 100.0
@export var startDirection = Vector2(0,1)

#@onready var animation_tree = $AnimationTree

signal bulletShoot(bullet, position, direction)

var mousePosition = null
var onHold = false

var shootDelay = 0.2   #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0

var health = 10

@onready var weapon = $Weapon

func _ready(): #sets the initial direction the sprite is facing
	#_updateDirection(startDirection)
	weapon.weaponFired.connect(self.shootBullet)

func _physics_process(_delta): #handles movement
	var direction = Vector2(Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left"),
	 		Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")).normalized()
	
	
	velocity = (direction * MovementSpeed)	
		
	move_and_slide()
	
func _process(_delta):  #mouse events
	isShooting(_delta)
	look_at(get_global_mouse_position())
	
func isShooting(_delta):
	if onHold:
		time_since_last_shot += _delta
		if time_since_last_shot >= shootDelay:	#makes sure to not shoot bullets instantly
			weapon.shootBullet()
			time_since_last_shot = 0
		
func _unhandled_input(event):
	if event.is_action_pressed("MouseLeft"):
		onHold = true
	if event.is_action_released("MouseLeft"):
		onHold = false

func shootBullet(bullet_instance, location, direction):
	emit_signal("bulletShoot", bullet_instance, location, direction)
		
func handle_hit():
	health -= 10	
#func _updateDirection(moveInput : Vector2): #updates the direction of the sprite
	#if(moveInput != Vector2.ZERO):
		#animation_tree.set("parameters/Walking/blend_position", moveInput)
