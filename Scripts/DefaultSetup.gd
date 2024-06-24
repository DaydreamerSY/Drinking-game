extends Node2D


# Called when the node enters the scene tree for the first time.

func _ready():
	var width: int
	var height: int
	
	print(OS.get_name())

	if OS.get_name() == "Windows":
		width = 900
		height = 1600
	elif OS.get_name() == "macOS":
		width = 1080
		height = 1920
	else:
		width = 720 # Default width for other OS
		height = 1080 # Default height for other OS

	DisplayServer.window_set_size(Vector2(width, height))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
