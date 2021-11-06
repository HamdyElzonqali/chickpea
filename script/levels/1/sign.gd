extends Node2D

var current_animation = 0
onready var anim = $animation
onready var audio = $audio_player

var sounds = [preload("res://audio/sfx/sign_creak1.wav"), 
			  preload("res://audio/sfx/sign_creak2.wav"),
			  preload("res://audio/sfx/sign_creak2.wav"),
			  preload("res://audio/sfx/sign_creak3_w_bug.wav")]


func _on_button_pressed():
	current_animation += 1
	if current_animation < anim.get_animation_list().size() + 1:
		anim.play("sign" + str(current_animation))
		audio.stream = sounds[current_animation - 1]
		audio.play()


func hit():
	Globals.camera.shake(3, 0.7)
	
	# do something
	# TODO: Play crash sound
