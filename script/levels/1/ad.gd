extends Node2D

var subtitles = [
	['I know you can`t afford that.', 3],
	['Neither do I...', 2]
]

var said = false

func initPos():
	position.x = Globals.camera.offset.x

func _ready():
	visible = false
	initPos()
	get_viewport().connect("size_changed", self, 'initPos')

func appear():
	$AnimationPlayer.play("show")
	visible = true


func _on_Button_pressed():
	Globals.camera.shake(1, 0.5)
	var win = get_node("../offer")
	win.global_position = Vector2(70, 90)
	if not said:
		said = true
		Globals.subtitle.show_for(subtitles[0][0], subtitles[0][1], false, 2)
		Globals.subtitle.delay(subtitles[1][0], subtitles[1][1], false, subtitles[0][1] + 2 + 1)
