extends Node2D

var front
var back
var content

# Called when the node enters the scene tree for the first time.
func _ready():
	front = $Front
	back = $Back
	content = $Content
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func face_up():
	front.visible = true
	back.visible = false

func face_down():
	front.visible = false
	back.visible = true

func update_content(text):
	content.text = text
