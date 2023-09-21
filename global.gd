extends Node

const BASE_RESOLUTION := Vector2i(416, 240)

var window_scale := 3

func _ready():
	get_window().size = BASE_RESOLUTION * window_scale

