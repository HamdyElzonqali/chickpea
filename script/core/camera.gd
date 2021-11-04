extends Camera2D

export var base_width = 320
export var base_height = 240

var current_scale = 1
var size = Vector2.ZERO
var view_offset = Vector2.ZERO

var shake_timer = 0
var shake_length = 0
var shake_amount = 0
var shake_offset = Vector2.ZERO

func shake(amount, time):
	shake_timer = time
	shake_length = time
	shake_amount = amount

func fit():
	size = get_viewport_rect().size
	current_scale = min(floor(size.x / base_width), floor(size.y / base_height)) 
	if current_scale < 2:
		current_scale = 2
	else:
		view_offset = Vector2(-(size.x - base_width * current_scale) / (2 * current_scale), -(size.y - base_height * current_scale) / (2 * current_scale))
		offset = view_offset
		zoom = Vector2(1 / current_scale, 1 / current_scale)

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.camera = self # setting global camera
	fit()
	
	# handle changes to screen size
	get_viewport().connect("size_changed", self, 'fit')
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		
		if shake_length == 0:
			shake_length = 1 # we can't devide by zero :(
		
		shake_offset.x = rand_range(-shake_amount, shake_amount) * (shake_timer / shake_amount)
		shake_offset.y = rand_range(-shake_amount, shake_amount) * (shake_timer / shake_amount)
	else:
		shake_offset.x = 0
		shake_offset.y = 0
	
	offset = view_offset + shake_offset
