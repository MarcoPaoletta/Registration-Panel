extends Control

onready var main_container: Node = $scroll_container/main_container

var button: Node
var container: Node
var user_txt: Node
var password_txt: Node
			
func _ready():
	g.load_data()
	
	for user in range(g.users):
		
		g.current_user = "user_" + str(user)
		
		button = Button.new()
		button.rect_min_size.y = 50
		button.connect("pressed", self, "button_pressed")
		button.add_to_group("buttons")
		button.name = g.current_user
		main_container.add_child(button)
		
		container = VBoxContainer.new()
		container.alignment = VALIGN_CENTER
		container.anchor_right = 1
		container.anchor_bottom = 1
		container.rect_size.x = 514
		button.add_child(container)
		
		user_txt = Label.new()
		user_txt.text = g.app["user_" + str(user)]["name"]
		container.add_child(user_txt)
		
		password_txt = Label.new()
		password_txt.text = g.app["user_" + str(user)]["password"]
		
		container.add_child(password_txt)

func button_pressed():
	for button in get_tree().get_nodes_in_group("buttons"):
		if button.pressed == true:
			g.current_user = button.name
	get_tree().change_scene("res://rsc/app/app.tscn")

func _on_exit_pressed():
	get_tree().change_scene("res://rsc/registration_panel/registration_panel.tscn")
