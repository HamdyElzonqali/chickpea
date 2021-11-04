extends ColorRect

var timer = 0
var is_playing = false

func _ready():
	Globals.glitch = self

func play_for(time = 1):
	material.set_shader_param('shake_rate', 1)
	timer = time
	is_playing = true
	visible = true
	
func _process(delta):
	if timer > 0:
		timer -= delta
		if timer <= 0 and is_playing:
			material.set_shader_param('shake_rate', 0)
			is_playing = false
			visible = false
