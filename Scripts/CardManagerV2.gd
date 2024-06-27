extends Node2D

@export var empty_card: PackedScene
var debug_text

var stock_pile
var discard_pile
var card_pile

var DEFAULT_PILE_SCALE = 0.4

var card_contents = []
var card_amount = 5
var card_stock_list = []
var card_discard_list = []

var swipe_length = 200
var curPos: Vector2
var startPos: Vector2
var swiping = false
var threshold = 50

var tween_in
var tween_out
var DEFAULT_SPEED = 0.4
var DEFAULT_ROTATE = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	stock_pile = $StockPile
	discard_pile = $DiscardPile
	card_pile = $CardPile
	
	debug_text = $Debug
	card_contents = GlobalVariant.card_contents["contents"]
	print(GlobalVariant.card_contents)
	start_game()
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("press"):
		
		swiping = true
		startPos = get_global_mouse_position()
		print("Start Pos: ", startPos)
	if Input.is_action_just_released("press"):
		
		swiping = false
		curPos = get_global_mouse_position()
		if startPos.distance_to(curPos) >= swipe_length:
			print("Swipe Dectected")
			if (startPos.x - curPos.x) >= threshold:
				print("Swipe from Right to Left")
				#if reveal_card():
					#discard_card()
				discard_card()
	else:
		swiping = false
			
	pass
	
func start_game():
	randomize()
	card_contents.shuffle()
	clear_pile()
	tween_in = create_tween()
	var _amount_of_cards = len(card_contents)
	var _speed_each_card = float(1.25) / float(_amount_of_cards)
	print(_speed_each_card)
	for i in range(_amount_of_cards):
		var _card = empty_card.instantiate()
		
		#_card.scale = Vector2(DEFAULT_PILE_SCALE,DEFAULT_PILE_SCALE)
		card_pile.add_child(_card)
		_card.face_down()
		_card.update_content(card_contents[i])
		#_card.visible=false
		card_stock_list.append(_card)
		_card.global_position = stock_pile.global_position
		tween_in.tween_property(
			_card,
			"position",
			Vector2(0, 0),
			_speed_each_card
		)
		
	card_stock_list[-1].face_up()

func clear_pile():
	var piles = [stock_pile, card_pile, discard_pile]
	for pile in piles:
		for n in pile.get_children():
			n.queue_free()

func reveal_card():
	var _card_list = stock_pile.get_children()
	if len(_card_list) == 0:
		start_game()
		return false
	var _last_card = _card_list[0]
	print(_last_card)
	
	var old_position = _last_card.get_global_position()
	_last_card.reparent(card_pile)
	_last_card.global_position = old_position
	
	#if tween_in:
		#tween_in.stop()
	tween_in = create_tween()
	tween_in.tween_property(
		_last_card,
		"position",
		Vector2(0, 0),
		0.5
	).set_trans(Tween.TRANS_SINE)
	tween_in.parallel().tween_property(
		_last_card,
		"scale",
		Vector2(1, 1),
		0.5
	).set_trans(Tween.TRANS_SINE)
	tween_in.tween_property(
		_last_card,
		"scale",
		Vector2(0, 1),
		DEFAULT_SPEED / 2
	)
	tween_in.tween_callback(_last_card.face_up)
	tween_in.tween_property(
		_last_card,
		"scale",
		Vector2(1, 1),
		DEFAULT_SPEED / 2
	)

	return true

func discard_card():
	var _card_list = card_pile.get_children()
	if len(_card_list) == 0:
		start_game()
		return false
	var _last_card = _card_list.pop_back()
	print(_last_card)
	#_last_card.rotation += randf_range(-0.05, 0.05)
	
	var old_position = _last_card.get_global_position()
	_last_card.reparent(discard_pile)
	_last_card.global_position = old_position
	
	#if tween_out:
		#tween_out.stop()
	tween_out = create_tween()
	tween_out.tween_property(
		_last_card,
		"position",
		Vector2(0, 0),
		DEFAULT_SPEED
	)
	tween_out.parallel().tween_property(
		_last_card,
		"scale",
		Vector2(DEFAULT_PILE_SCALE, DEFAULT_PILE_SCALE),
		DEFAULT_SPEED
	)
	tween_out.parallel().tween_property(
		_last_card,
		"rotation",
		_last_card.rotation + randf_range(-PI, PI),
		DEFAULT_SPEED
	)
	tween_out.tween_property(
		_last_card,
		"scale",
		Vector2(0, DEFAULT_PILE_SCALE),
		DEFAULT_SPEED / 2
	)
	tween_out.tween_callback(_last_card.face_down)
	tween_out.tween_property(
		_last_card,
		"scale",
		Vector2(DEFAULT_PILE_SCALE, DEFAULT_PILE_SCALE),
		DEFAULT_SPEED / 2
	)
	
	if len(_card_list) > 0:
		_card_list[-1].face_up()
	
	
	
	return true


