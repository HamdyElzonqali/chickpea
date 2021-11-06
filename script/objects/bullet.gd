extends Area2D

var speed = 250
var direction = 1
var cap = 7


func _on_Area2D_body_entered(body):
	if not body.get("isPlayer"):
		queue_free()

func _process(delta):
	cap -= delta
	if cap < 0:
		queue_free()
	if direction == 1:
		position.x += delta * speed
	elif direction == 2:
		position.x -= delta * speed
	elif direction == 3:
		position.y += delta * speed
	else:
		position.y -= delta * speed
