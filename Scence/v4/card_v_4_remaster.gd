class_name Card extends Node2D

@onready var label_content = $RotateViewport/SubViewport/DestroyViewport/SubViewport/Front/MarginContainer/Content


# tween rotate card & detroy
@onready var viewport_rotate = $RotateViewport
@onready var viewport_destroy = $RotateViewport/SubViewport/DestroyViewport

@export var angle_x_max: float = 25
@export var angle_y_max: float = 25

signal card_destroy

var is_press_on_card = false

var tween: Tween
var tween_rot: Tween
var tween_destroy: Tween
var tween_move: Tween

var percent_destroy_max: float = 0.5
var can_destroy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_content(new_content):
	label_content.text = new_content

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_press_on_card:
		_on_gui_input()
	pass

func destroy():
	z_index = 10
	if tween_rot and tween_rot.is_running():
		#tween_rot.kill()
		await tween_rot.finished
		card_destroy.emit()
	if tween_destroy and tween_destroy.is_running():
		await tween_destroy.finished
		
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(viewport_destroy.material, "shader_parameter/dissolve_value", 0.0, 1.5).from(1.0)
	await tween_destroy.finished
	queue_free()

func _on_gui_input():
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	var x_diff_from_center_card = mouse_pos.x - global_position.x
	var y_diff_from_center_card = mouse_pos.y - global_position.y
	
	# calculate % diff per Card.size
	var x_percent_diff = x_diff_from_center_card / viewport_rotate.size.x
	var y_percent_diff = y_diff_from_center_card / viewport_rotate.size.y
	
	if abs(x_percent_diff) >= percent_destroy_max or abs(y_percent_diff) >= percent_destroy_max:
		print(abs(x_percent_diff))
		print(abs(y_percent_diff))
		can_destroy = true
	else:
		can_destroy = false
		
	print(can_destroy)
	
	print("x diff: ", x_percent_diff)
	print("y diff: ", y_percent_diff)
	
	var rot_x: float = x_percent_diff * angle_x_max * -1
	var rot_y: float = y_percent_diff * angle_y_max
	
	viewport_rotate.material.set_shader_parameter("x_rot", rot_y)
	viewport_rotate.material.set_shader_parameter("y_rot", rot_x)


func _on_btn_select_button_down():
	is_press_on_card = true
	pass # Replace with function body.


func _on_btn_select_button_up():
	is_press_on_card = false
	
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(viewport_rotate.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(viewport_rotate.material, "shader_parameter/y_rot", 0.0, 0.5)
	
	if can_destroy:
		destroy()
	
	pass # Replace with function body.
