extends Node2D

var timer = 0
var delay_timer = 0
var playable = true
onready var label = $Label

var delayed = []

func _ready():
	Globals.subtitle = self

func show_for(text, time, playable = true, delay = 0):
	label.text = text
	timer = time
	playable = playable
	if delay > 0:
		delay_timer = delay
	else:
		Globals.player.playable = playable
		Globals.player.resetInput()
		visible = true
	
func delay(text, time, playable, delay):
	delayed.append([text, time, playable, delay])


func _process(delta):
	if delay_timer > 0:
		delay_timer -= delta
		if delay_timer <= 0:
			Globals.player.playable = playable
			Globals.player.resetInput()
			visible = true
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
			show_for(delayed[0][0], delayed[0][1], delayed[0][2])
			delayed.pop_front()
