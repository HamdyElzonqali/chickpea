extends Camera2D

var base_width = 320
var base_height = 240
var current_scale = 1

var size = Vector2.ZERO

func shake(amount, time):
	pass

func fit():
	size = get_viewport_rect().size
	current_scale = min(floor(size.x / base_width), floor(size.y / base_height)) 
	if current_scale > 0:
		zoom = Vector2(1 / current_scale, 1 / current_scale)
		offset = Vector2(-(size.x - base_width * current_scale) / (2 * current_scale), -(size.y - base_height * current_scale) / (2 * current_scale))

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.camera = self
	fit()
	
	# handle changes to screen side
	get_viewport().connect("size_changed", self, 'fit')
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
