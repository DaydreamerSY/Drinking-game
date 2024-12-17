extends RigidBody2D

signal card_exit_screen(card)

var front
var back
var content

var swipe_length = 10
var curPos: Vector2
var startPos: Vector2
var swiping = false
var threshold = 50
var touch_point

var card_id
var is_press_on_card = false
var on_screen_status = true

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
	
func update_id(id):
	card_id=id


func _input(event):
	if Input.is_action_just_pressed("press"):
			
		swiping = true
		startPos = get_global_mouse_position()
		#print("Start Pos: ", startPos)
		
	if Input.is_action_just_released("press"):
		
		swiping = false
		curPos = get_global_mouse_position()
		
		if startPos.distance_to(curPos) >= swipe_length and is_press_on_card:
			#print("Swipe Dectected")
			
			var flick_velocity = (curPos - startPos).normalized() * 5000
			
			#print("flick power and direction", flick_velocity)
			#print("before apply impulse: ", global_position)
			apply_impulse(
				flick_velocity,
				touch_point,
			)
			#print("after apply impulse: ", global_position)
				


func _on_btn_select_button_down():
	#print(card_id)
	#print(get_name())
	#print("Press on card at pos: ", get_local_mouse_position())
	touch_point = get_local_mouse_position()
	is_press_on_card = true
	pass # Replace with function body.


func _on_btn_select_button_up():
	is_press_on_card = false
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen_status = false
	card_exit_screen.emit(self)
	print(content.text)
	queue_free()
	pass # Replace with function body.


func _on_btn_select_mouse_exited():
	#print("mouse exited card")
	pass # Replace with function body.
