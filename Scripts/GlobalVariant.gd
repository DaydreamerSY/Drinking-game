extends Node

var http_request
var data_url = "https://opensheet.elk.sh/1TIEmAhKgK1IX2-0EfAxEZ73ruPjLnO1KOa8HiZ4dJgQ/Contents"
var card_contents: Dictionary = {
	"contents": []
}

var CONTENTS_DATA_FILE_NAME = "user://game-contents.json"

var RECT_SIZE = Vector2(1080, 1920)
