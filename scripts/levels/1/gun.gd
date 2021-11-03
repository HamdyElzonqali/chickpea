extends Node2D

var stuck = true
var current_mode = 0

onready var anim = $animation

func initPos():
	if stuck:
		position.y = -(int(get_viewport_rect().size.y) - Globals.camera.current_scale * Globals.camera.base_height) / (2 * Globals.camera.current_scale)

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
		stuck = false
		position.y = 50
		anim.play('gun3')
		$sprite.animation = 'bubble'
		get_node("../ad").appear()
		rotation = 0


func _on_button_pressed():
	step()
