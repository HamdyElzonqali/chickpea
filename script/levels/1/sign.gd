extends Node2D

var current_animation = 0
onready var anim = $animation

func _on_button_pressed():
	current_animation += 1
	if current_animation < anim.get_animation_list().size() + 1:
		anim.play("sign" + str(current_animation))

func hit():
	Globals.camera.shake(3, 0.7)
	
	# do something
	# TODO: Play crash sound