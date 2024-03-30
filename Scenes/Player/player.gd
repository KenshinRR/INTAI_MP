extends CharacterBody2D
@export var MovementSpeed = 50.0
@export var startDirection = Vector2(0,1)

signal bulletShoot(bullet, position, direction)
signal invi(owner)
signal scram(owner)
signal reload(owner)
signal died(owner)

var onClick = false

var shootDelay = 1.5  #delay in seconds ADJUST IF NEEDED
var time_since_last_shot = 0
var time_since_died = 0
var respawn_time = 5

@onready var health = $Health
var isDead = false
var FirstSpawn = true
var Spawner : int
var HSS
var Penacony 
var watchpoint
var prepTimer
var roundStart = false

@onready var weapon = $Weapon
@onready var power = preload("res://Scenes/Power Ups/power_up.tscn")
var pwn

@onready var animationSprite = $AnimatedSprite2D

func _ready(): #sets the initial direction the sprite is facing
	#_updateDirection(startDirection)
	if FirstSpawn:
		Spawner = randi_range(0,2)
		FirstSpawn = false
	
	Penacony = get_tree().get_nodes_in_group("Player Spawns")[Spawner]
	HSS = get_tree().get_nodes_in_group("Respawn Locations")[0]
	prepTimer = get_tree().get_first_node_in_group("PrepTimer")
	weapon.weaponFired.connect(self.shootBullet)
	#pwn = power.instantiate()
	#add_child(pwn)
	#pwn.caught.connect(self.power_handle)	
	
	global_position = Penacony.global_position

func _physics_process(_delta): #handles movement
	#dont move during round start
	if not roundStart:
		await prepTimer.timeout
		roundStart = true
		
	#moving
	var direction = Vector2(Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left"),
	 		Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")).normalized()
	
	velocity = (direction * MovementSpeed)	
	if MovementSpeed != 0:
		animationSprite.play("walking")
	else:
		animationSprite.play("default")
	
	move_and_slide()
	
	if isDead:
		handle_death()
	
func _process(_delta):  #mouse events
	time_since_last_shot += _delta
	isShooting(_delta)
	look_at(get_global_mouse_position())
	
	if isDead:
		time_since_died += _delta
	
	if isDead and time_since_died >= respawn_time:
		handle_respawn()
	
func isShooting(_delta):
	if onClick:
		#time_since_last_shot += _delta
		#if time_since_last_shot >= shootDelay:	#makes sure to not shoot bullets instantly
		weapon.shootBullet()
		time_since_last_shot = 0
		onClick = false
				
func _unhandled_input(event):
	if time_since_last_shot >= shootDelay:
		if event.is_action_pressed("MouseLeft"):
			onClick = true


func shootBullet(bullet_instance, location, direction):
	emit_signal("bulletShoot", bullet_instance, location, direction)
	emit_signal("reload","Player")

func power_handle(rando):
	if rando == 0:
		emit_signal("scram", "Player")
		print("chaos")
	if rando == 1:
		emit_signal("invi", "Player")
		print("invi")
	if rando == 2:
		health.health = 0
		isDead = true
		print("mines")
		
func handle_hit():
	health.health -= 10
	if health.health <= 0:
		ScoreManager.enemy_kills+= 1
		isDead = true
		emit_signal("died","Player")

func handle_respawn():
	global_position = Penacony.global_position
	isDead = false
	health.health = 10
	time_since_died = 0
	

func handle_death():
	global_position = HSS.global_position
	
	return
