extends Area2D


var subtitles = [
	['Is that a hidden wall?', 3]
]


func _on_Area2D_body_entered(body):
	if body.get('isBullet'):
		Globals.subtitle.play_for(subtitles[0][0], subtitles[0][1], false, 0.5)
		queue_free()
