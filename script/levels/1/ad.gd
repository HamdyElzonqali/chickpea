extends Node2D

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
