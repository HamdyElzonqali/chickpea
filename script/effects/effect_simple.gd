extends Node2D

func _ready():
	$annimation.frame = 0

func _on_AnimatedSprite_animation_finished():
	queue_free()
