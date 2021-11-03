extends Node2D

func initPos():
	position.x = -(int(get_viewport_rect().size.x) - Globals.camera.current_scale * Globals.camera.base_width) / (2 * Globals.camera.current_scale)

func _ready():
	initPos()
	visible = false
	get_viewport().connect("size_changed", self, 'initPos')

func appear():
	$AnimationPlayer.play("show")
	visible = true
