extends Node2D

var stuck = true
var current_mode = 0

onready var anim = $animation
var effect = preload("res://objects/effects/vanish.tscn")
var effect2 = preload("res://objects/effects/pop.tscn")
var playerArmed = preload("res://objects/characters/player_armed.tscn")

var timer = 0; var timer2 = 0;

var subtitles = [
	[''],
	['Don`t even think about it!', 3],
	['Fine!', 1],
	['Ha! Show me how you will get it!', 4.5],
	['Seriously!', 2]
]

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
		Globals.subtitle.show_for(subtitles[1][0], subtitles[1][1], false)
	elif current_mode == 2:
		Globals.subtitle.show_for(subtitles[2][0], subtitles[2][1], false)
		anim.play("gun3")
		stuck = false
		timer = 1

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
				anim.play('gun4')
				Globals.glitch.play_for(0.1)
				timer2 = 5
				Globals.subtitle.show_for(subtitles[3][0], subtitles[3][1], false)
				
			
			
	if timer2 > 0:
		timer2 -= delta
		if timer2 <= 0:
			get_node("../ad").appear()
			Globals.subtitle.show_for(subtitles[4][0], subtitles[4][1], false, 1)
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
