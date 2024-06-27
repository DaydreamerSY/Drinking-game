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
	
	if len(card_pile.get_children()) == 0:
		queue_free()
			
	pass
	
func start_game():
	randomize()
	card_contents.shuffle()
	var _amount_of_cards = len(card_contents)
	var _speed_each_card = float(3) / float(_amount_of_cards)
	print(_speed_each_card)
	var piles_distance = stock_pile.global_position - card_pile.global_position
	for i in range(_amount_of_cards):
		var _card = empty_card.instantiate()
		
		#_card.scale = Vector2(DEFAULT_PILE_SCALE,DEFAULT_PILE_SCALE)
		card_pile.add_child(_card)
		#_card.face_down()
		_card.update_content(card_contents[i])
		_card.update_id(i)
		#_card.visible=false
		card_stock_list.append(_card)
		#_card.position = Vector2(0, 0)
		#_card.scale = Vector2(3, 3)
	
	
		
func reset_position():
	position = Vector2(0, 0)




