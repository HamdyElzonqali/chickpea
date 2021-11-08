extends Node2D

func _ready():
	$animation.frame = 0


func _on_animation_animation_finished():
	queue_free()
