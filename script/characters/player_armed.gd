extends KinematicBody2D


# Main Variables
export var speed = 150 # pixel per second
export var gravity = 25
export var jumpForce = 350

# Getting Children
onready var anim = $anim
onready var bottomLeft  = $bottomLeft
onready var bottomRight = $bottomRight

# Variables
var isPlayer  = true # used for physics detection 
var direction = 1 # 1 for right, -1 for left
var playable  = true # handle input or not
var mVelocity = Vector2.ZERO # how we should move the player based on input
var velocity  = Vector2.ZERO # extra velocity beside movement.
var canJump   = false
var current_animation = 'idle'
var extraJumpTime = 0.05 # to make the jump feel more responsive on the edge
var jumpTimer = 0
var stretch = Vector2.ONE


var state = "right" # right, up, down
var fire_delay = 0.15
var fire_timer = 0
var offset = Vector2.ZERO
var bullet = preload("res://objects/objects/bullet.tscn")

var instance

signal shoot

onready var audio = $audio_player
var jumpSound = preload("res://audio/sfx/GameOff Jump 1.23.wav")

var peaShooter = [
	preload("res://audio/sfx/peashooter 1.1.wav"),
	preload("res://audio/sfx/peashooter 2 1.1.wav")
]

var peaShooterIndex = 0

# Input
var left = false; var right = false;
var up   = false; var down  = false;
var jump = false; var jumpTap = false
var fire = false;

func resetInput():
	left = false; right = false;
	up   = false; down  = false;
	jump = false; jumpTap = false
	fire = false;

func handleInput():
	left  = Input.is_action_pressed('left')
	right = Input.is_action_pressed('right')
	up    = Input.is_action_pressed('up')
	down  = Input.is_action_pressed('down')
	jump  = Input.is_action_pressed("jump")
	jumpTap = Input.is_action_just_pressed("jump")
	fire  = Input.is_action_pressed("fire")

func handleMovement(delta):
	current_animation = 'idle' # the animation is idle by default
	
	velocity.x = lerp(velocity.x, 0, 8 * delta)
	
	if up:
		state = 'up'
	elif down:
		state = 'down'
	else:
		state = 'right'
	
	if not left and not right:
		mVelocity.x =  lerp(mVelocity.x, 0, delta * 40) # lerp is used to make stopping smooth
	else:
		mVelocity.x = 0

	if left:
		mVelocity.x -= speed
		current_animation = 'run'
	if right:
		mVelocity.x += speed
		current_animation = 'run'
		
	mVelocity.y += gravity 
	velocity.y += gravity
	if velocity.y < 0 and mVelocity.y > 0:
		mVelocity.y = 0
		
	if velocity.y > 0:
		velocity.y = 0
	
	if left or right:
		if mVelocity.x > 0:
			direction = 1
			anim.scale.x = 1
		elif mVelocity.x < 0:
			anim.scale.x = -1
			direction = -1
		else:
			current_animation = 'idle'
		if is_on_wall():
			current_animation = 'idle'
	else:
		# while the player is standing still
		if direction > 0:
			if bottomLeft.is_colliding() and not bottomRight.is_colliding():
				current_animation = 'edge'
		else:
			if bottomRight.is_colliding() and not bottomLeft.is_colliding():
				current_animation = 'edge'

	if jumpTimer > 0:
		jumpTimer -= delta
		if jumpTap:
			jumpTimer = 0
			mVelocity.y = -jumpForce
			canJump = false
			
			audio.stream = jumpSound
			audio.volume_db = Globals.sfx
			audio.play()
	
	if mVelocity.y < 0:
		# hold jump for a higher jump
		if not jump:
			mVelocity *= 0.7
	
	move_and_slide(velocity + mVelocity, Vector2.UP)
	
	if is_on_floor():
		mVelocity.y = 50 # 20 instead of 0 for a smoother fall from edge
		canJump = true
		jumpTimer = extraJumpTime
		stretch.x = 1 * direction
		stretch.y = 1
	else:
		canJump = false
		if mVelocity.y > 0:
			current_animation = 'fall'
			stretch.x = 0.95 * direction
			stretch.y = 1.1
		else:
			stretch.x = 1.05 * direction
			stretch.y = 0.9
			current_animation = 'jump'

	if is_on_ceiling():
		mVelocity.y = 1
	
	anim.animation = state + '_' + current_animation

	if fire_timer > 0:
		fire_timer -= delta
	else:
		if fire:
			fire_timer = fire_delay
			Globals.camera.shake(5, 0.4)
			
			instance = bullet.instance()
			if up:
				instance.direction = 4
				offset.x = direction * -3
				offset.y = -6
				velocity = Vector2(0, 20)
			elif down:
				instance.direction = 3
				offset.x = 0
				offset.y = 6
				velocity = Vector2(0, -20)
			elif direction == 1:
				instance.direction = 1
				offset.x = 8
				offset.y = 2
				velocity = Vector2(-20, 0)
			else:
				instance.direction = 2
				offset.x = -8
				offset.y = 2
				velocity = Vector2(20, 0)
				
			instance.global_position = global_position + offset
			get_viewport().get_child(0).add_child(instance)
			
			audio.volume_db = Globals.sfx
			audio.stream = peaShooter[peaShooterIndex]
			audio.play()
			
			peaShooterIndex = (peaShooterIndex + 1) % peaShooter.size()
			
			emit_signal("shoot")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player = self


# Called every physics frame. (60 times per second)
func _physics_process(delta):
	anim.scale = lerp(anim.scale, stretch, 30 * delta)
	handleMovement(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playable:
		handleInput()
