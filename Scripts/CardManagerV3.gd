extends Node2D

@export var empty_card: PackedScene

signal finish_round

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

# Called when the node enters the scene tree for the first time.
func _ready():
	#stock_pile = $StockPile
	#discard_pile = $DiscardPile
	card_pile = $CardPile
	debug_text = $Debug
	particle = $Particle
	#card_contents = GlobalVariant.card_contents["contents"].slice(0, 5)
	reload_pile()
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

func reload_pile():
	print("reload pile")
	card_contents = GlobalVariant.card_contents["contents"].duplicate(true)
	#print(card_contents)
	
	randomize()
	card_contents.shuffle()
	print(card_contents.size())
	var _amount_of_cards = len(card_contents)
	
	GlobalVariant.CURRENT_DECK = card_contents.duplicate(true)

	card_pile.visible = false
	for i in range(_amount_of_cards):
	#for i in range(5):
		var _card = empty_card.instantiate()
		card_pile.add_child(_card)
		_card.update_content(card_contents[i])
		_card.update_id(i)
		card_stock_list.append(_card)
		_card.card_exit_screen.connect(on_card_exit_screen)
		
	return true

	
func on_card_exit_screen(card):
	#print("some card exit screen")
	#print("Card pile in stock: ", len(card_pile.get_children()))
	
	GlobalVariant.PLAYED_CARD.append(card.content.text)
	if len(card_pile.get_children()) == 1:
		print("Out of card")
		print(card)
		finish_round.emit()
	#if len(card_pile.get_children()) == 1:
		#print("out of cards")
		#reload_pile()
	pass
	
	
		
func start_game():
	card_pile.visible = true
	#reload_pile()
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
