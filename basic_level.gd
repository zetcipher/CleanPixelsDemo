extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("moved", move_cam)


func move_cam(pos: Vector2):
	$Camera2D.position = pos.snapped(Vector2.ONE)
