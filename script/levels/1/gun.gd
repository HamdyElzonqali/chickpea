extends Node2D

var stuck = true
var current_mode = 0

onready var anim = $animation

var timer = 0; var timer2 = 0;

func initPos():
	if stuck:
		position.y = Globals.camera.offset.y

func _ready():
	visible = false
	initPos()
	
	get_viewport().connect("size_changed", self, 'initPos')

func step():
	if visible:
		current_mode += 1
	if current_mode == 1:
		anim.play("gun2")
	elif current_mode == 2:
		anim.play("gun3")
		stuck = false
		timer = 2

func _process(delta):
	if timer > 0:
		timer -= delta
		if timer <= 0:
			if visible:
				visible = false
				position.y = 50
				rotation = 0
				$sprite.animation = 'bubble'
				anim.play('gun4')
				timer = 0.4
			else:
				visible = true
				timer2 = 3
			
			
	if timer2 > 0:
		timer2 -= delta
		if timer2 <= 0:
			get_node("../ad").appear()
func _on_button_pressed():
	step()
