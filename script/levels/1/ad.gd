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
