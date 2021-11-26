extends Node2D

onready var bar = $TextureProgress
onready var sfx = $AudioStreamPlayer
var ready = false

func _ready():
	visible = false

func setup():
	ready = true

func _on_Area2D_area_entered(area):
	if ready:
		area.queue_free()
		bar.value -= 5
		visible = true
		Globals.camera.shake(20, 0.4)
		Globals.glitch.play_for(1 - (bar.value / 100))
		sfx.play()
		if bar.value <= 0:
			get_tree().get_root().get_child(0).queue_free()
			get_tree().change_scene("res://credits.tscn")
		
