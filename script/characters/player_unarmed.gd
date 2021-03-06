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

# Input
var left = false; var right = false;
var up   = false; var down  = false;
var jump = false; var jumpTap = false
#var fire  = false;

onready var audio = $audio_player
var jumpSound = preload("res://audio/sfx/GameOff Jump 1.23.wav")

var running_dust = preload("res://objects/effects/running_dust.tscn")
var running_dust_delay = 0.5

#var jump_dust = preload("res://objects/effects/jump_dust.tscn")
#var land_dust = preload("res://objects/effects/land_dust.tscn")

func resetInput():
	left = false; right = false;
	up   = false; down  = false;
	jump = false; jumpTap = false
	
func handleInput():
	left  = Input.is_action_pressed('left')
	right = Input.is_action_pressed('right')
	up    = Input.is_action_pressed('up')
	down  = Input.is_action_pressed('down')
	jump  = Input.is_action_pressed("jump")
	jumpTap = Input.is_action_just_pressed("jump")
	#fire  = Input.is_action_pressed("fire")

var running_dust_timer = 0
var instance
func runningDust(delta):
	if running_dust_timer < 0:
		running_dust_timer = running_dust_delay
	else:
		running_dust_timer -= delta
		if running_dust_timer < 0:
			instance = running_dust.instance()
			get_viewport().get_child(0).add_child(instance)
			instance.global_position = global_position + Vector2(0, 4)
			instance.scale.x = direction

func handleMovement(delta):
	current_animation = 'idle' # the animation is idle by default
	
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
		if current_animation != 'idle' and is_on_floor():
			pass #runningDust(delta)
	else:
		running_dust_timer = 0
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
			#jump
			jumpTimer = 0
			mVelocity.y = -jumpForce
			canJump = false
			
			audio.stream = jumpSound
			audio.volume_db = Globals.sfx
			audio.play()
			
			#instance = jump_dust.instance()
			#get_viewport().get_child(0).add_child(instance)
			#instance.global_position = global_position
			#instance.scale.x = direction
			
	if mVelocity.y < 0:
		# hold jump for a higher jump
		if not jump:
			mVelocity *= 0.7
	
	move_and_slide(velocity + mVelocity, Vector2.UP)
	
	if is_on_floor():
		#if not canJump:
			#instance = land_dust.instance()
			#get_viewport().get_child(0).add_child(instance)
			#instance.global_position = global_position + Vector2(0, 4)
			#instance.scale.x = direction
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
	
	anim.animation = current_animation


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
