extends CharacterBody2D
@export var MovementSpeed = 50.0
@export var startDirection = Vector2(0,1)

#@onready var animation_tree = $AnimationTree

signal bulletShoot(bullet, position, direction)

var onHold = false

var shootDelay = 2   #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0

var health = 120
var isDead = false

@onready var weapon = $Weapon
@onready var power = preload("res://Scenes/Power Ups/power_up.tscn")
var pwn
func _ready(): #sets the initial direction the sprite is facing
	#_updateDirection(startDirection)
	weapon.weaponFired.connect(self.shootBullet)
	#pwn = power.instantiate()
	#add_child(pwn)
	#pwn.caught.connect(self.power_handle)
	

func _physics_process(_delta): #handles movement
	var direction = Vector2(Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left"),
	 		Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")).normalized()
	
	velocity = (direction * MovementSpeed)	
	
	move_and_slide()
	
	if isDead:
		handle_death()
	
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

func power_handle(rando):
	if rando == 0:
		health = 0
		isDead = true
		print("chaos")
		
func handle_hit():
	health -= 10
	if health <= 0:
		isDead = true

func handle_death():
	$Sprite2D.visible = false
	return
