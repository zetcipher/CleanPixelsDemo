extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connecting the window's "size_changed" signal to the "set_interp" function.
	# We only need to set the interpolation status/strength when
	# the window changes size, do doing this is preferred over
	# repeatedly calling the function in _process().
	get_window().connect("size_changed", set_interp)
	
	# Also should be noted that "size_changed" is a signal from Viewport, which Window inherits from.


func set_interp():
	# Get the window's size
	var window_size := get_window().size
	# Determining the scale of the window, by dividing the window size by the base resolution.
	var window_scale := Vector2(window_size) / Vector2(Global.BASE_RESOLUTION)
	var non_integer_scale := false
	
	# Checking if both the X and Y scales are non-integer values.
	# If the visible aspect ratio is kept (which it is by default),
	# the game will still be shown with an integer scale if one is mismatched.
	# You might need to provide some more complicated/lenient logic if you want to
	# have the visible aspect ratio change to the window's aspect ratio.
	if (window_scale.x > floor(window_scale.x)) and (window_scale.y > floor(window_scale.y)): 
		non_integer_scale = true
	
	# Getting the shader material as a variable
	var shader := self.material as ShaderMaterial
	
	# Setting whether or not interpolation should occur at all.
	shader.set_shader_parameter("linear_interp", non_integer_scale)
	if non_integer_scale:
		# Determining the maximum integer scale that will fit within the window.
		# The minimum value between the X and Y scales should be used, 
		# since that's what you'll see in the window.
		var max_scale : int = min(floor(window_scale.x), floor(window_scale.y))
		# Setting the interpolation sharpness.
		shader.set_shader_parameter("interp_sharpness", Vector2i(max_scale, max_scale))
