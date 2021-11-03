extends Area2D


signal pressed;
signal unpressed;
signal isPressed;

var pressable = false
var down = false
onready var anim = $animation

func _ready():
	connect("body_entered", self, 'onPressed')
	connect("body_exited", self, 'onUnpressed')

func _process(delta):
	if pressable:
		if down:
			isPressed()

func onPressed(body):
	Globals.camera.shake(2, 0.5)
	down = true
	anim.animation = 'pressed'
	emit_signal('pressed')

func onUnpressed(body):
	down  = false
	anim.animation = 'unpressed'
	emit_signal('unpressed')

func isPressed():
	emit_signal('isPressed')
