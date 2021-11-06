extends Area2D


signal pressed;
signal unpressed;
signal isPressed;

var pressable = false
var down = false
onready var anim = $animation
onready var audio = $audio_player

var pos = 0
var sounds = [
	preload("res://audio/sfx/ground_shake1.wav"),
	preload("res://audio/sfx/ground_shake2.wav")
]

func _ready():
	connect("body_entered", self, 'onPressed')
	connect("body_exited", self, 'onUnpressed')

func _process(delta):
	if pressable:
		if down:
			isPressed()

func onPressed(body):
	audio.volume_db = Globals.sfx
	audio.stream = sounds[pos]
	audio.play()
	pos = (pos + 1) % sounds.size()
	Globals.camera.shake(2, 0.5)
	down = true
	anim.animation = 'pressed'
	emit_signal('pressed')

func onUnpressed(body):
	# TODO: play sound
	down  = false
	anim.animation = 'unpressed'
	emit_signal('unpressed')

func isPressed():
	emit_signal('isPressed')
