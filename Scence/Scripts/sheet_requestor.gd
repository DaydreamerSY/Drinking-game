extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#geturl = Your appscirpt web app url + ?sheetname=YourSheetname
#apiurl = Your appscript web app url 
#replace get and api url with your urls, this is just example urls 
#var getsheetname = "Contents" # sheet name from where you want to get data 
#var apiurl = "https://script.google.com/macros/s/AKfycbyI9OjBhffy_hdRgjbPRoxN_8BmwvqoAU10NFAkpEFMWhMdhKTmXuuMzgRIUlSg6bc/exec"
#var geturl = apiurl+"?sheetname="+getsheetname
#
#func getdata():
  #$HTTPRequest.request(geturl)
#
#func _on_HTTPRequest_request_completed(result, response_code, headers, body):
			#var data = body.get_string_from_utf8()
			#data = data.replace("[","").replace("]","")
			#data = parse_json(data)
			##print(data)
			#print(data["TOTAL_CASH_IN_HAND"]) # you can access data based on key name 
