extends KinematicBody2D


# Main Variables
export var speed = 150 # pixel per second
export var gravity = 25
export var fall_speed = 150 # maximum falling speed
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


# Input
var left = false; var right = false;
var up   = false; var down  = false;
var jump = false; var jumpTap = false
var fire = false;

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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every physics frame. (60 times per second)
func _physics_process(delta):
	anim.scale = lerp(anim.scale, stretch, 30 * delta)
	handleMovement(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playable:
		handleInput()
