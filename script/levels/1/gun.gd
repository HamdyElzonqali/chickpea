extends Node2D

var stuck = true
var current_mode = 0

onready var anim = $animation
var effect = preload("res://objects/effects/vanish.tscn")
var effect2 = preload("res://objects/effects/pop.tscn")
var playerArmed = preload("res://objects/characters/player_armed.tscn")

var timer = 0; var timer2 = 0;

func initPos():
	if stuck:
		position.y = Globals.camera.offset.y

func _ready():
	visible = false
	initPos()
	
	get_viewport().connect("size_changed", self, 'initPos')

func step():
	if visible:
		current_mode += 1
	if current_mode == 1:
		anim.play("gun2")
	elif current_mode == 2:
		anim.play("gun3")
		stuck = false
		timer = 2

func _process(delta):
	if timer > 0:
		timer -= delta
		if timer <= 0:
			if visible:
				var instance = effect.instance()
				get_viewport().get_child(0).add_child(instance)
				instance.global_position = position + Vector2(-18, 8)
				visible = false
				position.y = 50
				rotation = 0
				$sprite.animation = 'bubble'
				anim.play('gun4')
				Globals.glitch.play_for(0.1)
				timer = 1
			else:
				var instance = effect2.instance()
				get_viewport().get_child(0).add_child(instance)
				instance.global_position = position + Vector2(-8, 0)
				visible = true
				Globals.glitch.play_for(0.1)
				timer2 = 5
			
			
	if timer2 > 0:
		timer2 -= delta
		if timer2 <= 0:
			get_node("../ad").appear()
func _on_button_pressed():
	step()


func _on_collision_body_entered(body):
	if body.get('isPlayer'):
		var scene = get_viewport().get_child(0)
		Globals.glitch.play_for(0.1)
		var instance = effect.instance()
		scene.add_child(instance)
		instance.global_position = position + Vector2(-8, 0)
		
		instance = playerArmed.instance()
		scene.add_child(instance)
		scene.move_child(instance, scene.get_child_count() - 2)
		instance.global_position = body.position
		
		get_node('../offer').queue_free()
		get_node('../ad').queue_free()
		body.queue_free()
		# TODO: play sound
		queue_free()
