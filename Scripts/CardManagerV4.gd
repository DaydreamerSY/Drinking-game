class_name CardManager extends Node2D

@export var empty_card: PackedScene
var debug_text

var particle
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

#var card_pile = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#stock_pile = $StockPile
	#discard_pile = $DiscardPile
	card_pile = $CardPile
	debug_text = $Debug
	particle = $Particle
	load_pile()
	pass # Replace with function body.
	
func _process(delta):
	particle.position = get_global_mouse_position()	
	
	if Input.is_action_pressed("press"):
		particle.emitting = true
	else:
		particle.emitting = false
		#print("Start Pos: ", startPos)
		
	#if Input.is_action_just_released("press"):
		#particle.visible = false
		#particle.position = Vector2(-100, -100)
		


func load_pile():
	print("reload pile")
	card_contents = GlobalVariant.card_contents["contents"]
	#print(card_contents)
	
	randomize()
	card_contents.shuffle()
	#var _amount_of_cards = len(card_contents)
#
	#card_pile.visible = false
	#for i in range(_amount_of_cards):
		#var _card = empty_card.instantiate()
		#
		#card_pile.add_child(_card)
		#_card.update_content(card_contents[i])
		#_card.update_id(i)
		#card_stock_list.append(_card)
		#_card.card_exit_screen.connect(on_card_exit_screen)
	
	get_card()
	
		
	return true

func get_card():
	var _card = empty_card.instantiate()
	var _content = card_contents.pop_front()
	print(card_contents)
	print(_content)
	card_pile.add_child(_card)
	_card.update_content(_content)
	card_stock_list.append(_card)
	_card.card_exit_screen.connect(on_card_exit_screen)
	
func on_card_exit_screen():
	print("some card exit screen")
	print("Card pile in stock: ", len(card_pile.get_children()))
	if len(card_pile.get_children()) == 1:
		print("out of cards")
		load_pile()
	pass
	
	
		
func start_game():
	card_pile.visible = true
	#print(card_pile.get_children())
	var _last_card = card_pile.get_children()[-1]
	_last_card.scale = Vector2(2, 2)
	var _tween = create_tween()
	_tween.tween_property(
		_last_card,
		"scale",
		Vector2(1, 1),
		1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
