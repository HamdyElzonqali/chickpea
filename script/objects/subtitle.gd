extends Node2D

var timer = 0
var delay_timer = 0
var playable = true
var voice_over = null
onready var label = $Label

onready var audio = $audio_player
var delayed = []

func _ready():
	Globals.subtitle = self

func show_for(text, time, playable = true, delay = 0, voice = null):
	label.text = text
	timer = time
	playable = playable
	voice_over = voice
	
	if delay > 0:
		delay_timer = delay
	else:
		Globals.player.playable = playable
		Globals.player.resetInput()
		visible = true
		if voice_over:
			audio.volume_db = Globals.voice
			audio.stream = voice_over
			audio.play()
	
func delay(text, time, playable, delay, voice_over = null):
	delayed.append([text, time, playable, delay, voice_over])

func clear():
	delayed.clear()
	visible = false

func _process(delta):
	if delay_timer > 0:
		delay_timer -= delta
		if delay_timer <= 0:
			Globals.player.playable = playable
			Globals.player.resetInput()
			visible = true
			if voice_over:
				audio.volume_db = Globals.voice
				audio.stream = voice_over
				audio.play()
	else:
		if timer > 0:
			timer -= delta
			if timer <= 0:
				visible = false
				playable = true
				Globals.player.playable = true

	if delayed.size() > 0:
		delayed[0][3] -= delta
		if delayed[0][3] < 0:
			show_for(delayed[0][0], delayed[0][1], delayed[0][2], 0, delayed[0][4])
			delayed.pop_front()
