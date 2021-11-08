extends Node2D

var current_animation = 0
onready var anim = $animation
onready var audio = $audio_player

var sounds = [preload("res://audio/sfx/sign_creak1.wav"), 
			  preload("res://audio/sfx/sign_creak2.wav"),
			  preload("res://audio/sfx/sign_creak2.wav"),
			  preload("res://audio/sfx/sign_creak3_w_bug.wav")]

var subtitles = [
	['What have you done?', 2, preload("res://audio/voice_over/What Have You Done 1.0.wav")],
	['There is a reason this sign is there.', 3, preload("res://audio/voice_over/There's A Reason This Sign Is There 1.1.wav")],
	['Stop it!', 1, preload("res://audio/voice_over/Stop It 1.0.wav")],
	['ُEnough!', 1, preload("res://audio/voice_over/Enough 1.0.wav")],
	['NO NO NO...', 2, preload("res://audio/voice_over/No No No 1.0.wav")]
]

func _on_button_pressed():
	current_animation += 1
	if current_animation < anim.get_animation_list().size() + 1:
		anim.play("sign" + str(current_animation))
		audio.stream = sounds[current_animation - 1]
		audio.volume_db = Globals.sfx
		audio.play()
		Globals.subtitle.show_for(subtitles[current_animation - 1][0], subtitles[current_animation - 1][1], false, 0, subtitles[current_animation - 1][2])


func hit():
	Globals.camera.shake(3, 0.9)
	Globals.subtitle.show_for(subtitles[4][0], subtitles[4][1], false, 0.5, subtitles[4][2])
