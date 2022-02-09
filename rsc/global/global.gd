extends Node

var current_user: String

var users: int

var app: Dictionary = { }

var path = "user://data.json"

func _process(_delta):
	users = app.keys().size()
	print(app.keys())

func load_data():
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path, file.READ)
	var text = file.get_as_text()
	app = parse_json(text)
	file.close()

func save_data():
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(JSON.print(app, "\t"))
	file.close()

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
