class_name Playground extends Node2D

#@onready var card_scene: PackedScene = load("res://Scence/v4/card_v4.tscn")
@export var card_scene: PackedScene

var deck_pile = []
var deck_pile_content = []

@onready var card_pile_position = $CardPile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	#print(GlobalVariant.card_contents["contents"])
	setup_cardpile_position()
	load_pile()
	get_next_card()
	pass
	
func load_pile():
	# Load data from GlobalVariant.card_contents -> deck_pile_content
	deck_pile_content = GlobalVariant.card_contents["contents"].duplicate(true)
	deck_pile_content.shuffle()
	print(len(deck_pile_content))
	
func get_next_card():
	var _instance = card_scene.instantiate()
	card_pile_position.add_child(_instance)
	_instance.card_destroy.connect(get_next_card)
	
	var _content = deck_pile_content.pop_front()
	
	_instance.update_content(_content)
	pass
	
func destroy():
	deck_pile.pop_front().destroy()
	pass
	

func shuffle_pile():
	randomize()
	deck_pile_content.shuffle()
	
	pass


func setup_cardpile_position():
	print(DisplayServer.window_get_size())
	#var screen_size = DisplayServer.window_get_size()
	var screen_size = GlobalVariant.RECT_SIZE
	
	print(screen_size)
	
	card_pile_position.position.y = screen_size.y * 1/2
	card_pile_position.position.x = screen_size.x * 1/2
	
	print(card_pile_position.position)
	pass
