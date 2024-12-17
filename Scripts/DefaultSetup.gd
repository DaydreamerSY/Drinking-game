class_name Main extends Control

#@export var playground : PackedScene

@onready var playground = $"Drinking v3"
@onready var button_start = $CanvasLayer/Start
@onready var http_request = $HTTPRequest
@onready var debug_view = $CanvasLayer/MarginContainer/TextEdit

func _ready():
	var width: int
	var height: int
	
	print(OS.get_name())

	if OS.get_name() == "Windows":
		width = 540
		height = 960
		DisplayServer.window_set_position(DisplayServer.window_get_position() + Vector2i(100, 100))
	elif OS.get_name() == "macOS":
		width = 1080
		height = 1920
	else:
		width = 1080 # Default width for other OS
		height = 1920 # Default height for other OS

	DisplayServer.window_set_size(Vector2(width, height))
	
	
	
	print("Load globalVariant")
	
	if not load_game():
		http_request.request_completed.connect(_on_request_completed)
		http_request.request(GlobalVariant.data_url)
		load_game()
		
	#playground.reload_pile()
	playground.finish_round.connect(_on_finished_round)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_finished_round():
	button_start.visible = true

func _on_start_pressed():
	button_start.visible = false
	playground.reload_pile()
	playground.start_game()
	pass # Replace with function body.

#region GetDataFromSheet

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print("Requesting...")
	print(json)
	for row in json:
		GlobalVariant.card_contents["contents"].append(row["Content"])
		
	save_game()
		
	#debug_text.text = str(GlobalVariant.card_contents)
	#start_game()

func save_game():
	var save_game = FileAccess.open(GlobalVariant.CONTENTS_DATA_FILE_NAME, FileAccess.WRITE)
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var json_string = JSON.stringify(GlobalVariant.card_contents)

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists(GlobalVariant.CONTENTS_DATA_FILE_NAME):
		print("can't not find save files")
		return false# Error! We don't have a save to load.


	var save_game = FileAccess.open(GlobalVariant.CONTENTS_DATA_FILE_NAME, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		GlobalVariant.card_contents = json.get_data()
		#print(GlobalVariant.card_contents)
		return true
	print("Reach here no matter what")



func _on_update_content_pressed():
	print("update content")
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(GlobalVariant.data_url)

#endregion


func _on_debug_view_pressed() -> void:
	debug_view.visible = !debug_view.visible
	debug_view.text = ""
	#debug_view.text = "\n".join(GlobalVariant.card_contents["contents"])
	var count = 1
	#for i in GlobalVariant.CURRENT_DECK:
		#debug_view.text += "{count}. {content}\n".format({
			#"count": count,
			#"content": i
		#})
		#count += 1
		
	debug_view.text += "\n------- Played cards -------\n"
	
	count = 1
	for i in GlobalVariant.PLAYED_CARD:
		debug_view.text += "{count}. {content}\n".format({
			"count": count,
			"content": i
		})
		count += 1
	pass # Replace with function body.
