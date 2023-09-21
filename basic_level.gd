extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("moved", move_cam)


func move_cam(pos: Vector2):
	# Setting the camera's position to the player's position snapped to an integer value.
	$Camera2D.position = pos.snapped(Vector2.ONE)
