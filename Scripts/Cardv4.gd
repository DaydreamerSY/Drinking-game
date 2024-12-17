extends RigidBody2D

signal card_exit_screen

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

# tween rotate card
@export var angle_x_max: float = 15
@export var angle_y_max: float = 15

var mouse_on_card = false

var tween
var tween_hover
var tween_rot



# Called when the node enters the scene tree for the first time.
func _ready():
	front = $SubViewportContainer
	#back = $Back
	content = $SubViewportContainer/SubViewport/Front/Content
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_on_card:
		_on_gui_input()
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


#func _input(event):
	#if Input.is_action_just_pressed("press"):
		#mouse_on_card = true
		#swiping = true
		#startPos = get_global_mouse_position()
		##print("Start Pos: ", startPos)
		#
	#if Input.is_action_just_released("press"):
		#mouse_on_card = false
		#swiping = false
		#curPos = get_global_mouse_position()
		#
		#if startPos.distance_to(curPos) >= swipe_length and is_press_on_card:
			#print("Swipe Dectected")
			#
			#var flick_velocity = (curPos - startPos).normalized() * 5000
			#
			#print("flick power and direction", flick_velocity)
			#print("before apply impulse: ", global_position)
			#apply_impulse(
				#flick_velocity,
				#touch_point,
			#)
			#print("after apply impulse: ", global_position)
				

func _on_gui_input():
	
	# Handles rotation
	# Get local mouse possprite.size
	#print("=====================")
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	var x_diff_from_center_card = mouse_pos.x - global_position.x
	var y_diff_from_center_card = mouse_pos.y - global_position.y
	#print("x diff: ", x_diff_from_center_card)
	#print("y diff: ", y_diff_from_center_card)
	
	# calculate % diff per Card.size
	var x_percent_diff = x_diff_from_center_card / front.size.x
	var y_percent_diff = y_diff_from_center_card / front.size.y
	
	
	#print("x diff (%): ", x_diff_from_center_card)
	#print("y diff (%): ", y_diff_from_center_card)

	var rot_x: float = x_percent_diff * angle_x_max * -1
	var rot_y: float = y_percent_diff * angle_y_max
	#print("Rot x: ", rot_x)
	#print("Rot y: ", rot_y)
	
	front.material.set_shader_parameter("x_rot", rot_y)
	front.material.set_shader_parameter("y_rot", rot_x)




func _on_btn_select_button_down():
	print(card_id)
	print(get_name())
	mouse_on_card = true
	print("Press on card at pos: ", get_local_mouse_position())
	touch_point = get_local_mouse_position()
	is_press_on_card = true
	pass # Replace with function body.


func _on_btn_select_button_up():
	is_press_on_card = false
	mouse_on_card = false
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen_status = false
	card_exit_screen.emit()
	queue_free()
	pass # Replace with function body.


func _on_btn_select_mouse_exited():
	mouse_on_card = false
	print("mouse exited card")
	
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(front.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(front.material, "shader_parameter/y_rot", 0.0, 0.5)
	pass # Replace with function body.


func _on_btn_select_mouse_entered():
	#mouse_on_card = true
	pass # Replace with function body.
