extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().connect("size_changed", set_interp)


func set_interp():
	var window_size := get_window().size
	var window_scale := Vector2(window_size) / Vector2(Global.BASE_RESOLUTION)
	var non_integer_scale := false
	
	if (window_scale.x > floor(window_scale.x)) and (window_scale.y > floor(window_scale.y)): 
		non_integer_scale = true
	
	var shader := self.material as ShaderMaterial
	
	shader.set_shader_parameter("linear_interp", non_integer_scale)
	if non_integer_scale:
		var max_scale : int = min(floor(window_scale.x), floor(window_scale.y))
		shader.set_shader_parameter("interp_sharpness", Vector2i(max_scale, max_scale))
