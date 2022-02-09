extends Panel

onready var user_txt: Node = $container/user_txt
onready var password_txt: Node = $container/password_txt

func _ready():
	g.load_data()

func try_new_user_creation():

	if password_txt.text.length() < 2:
		print("menor cantidad de caracteres en la contraseña")
		return
		
	# the user is already created
	for user in range(g.users):
		if user_txt.text in g.app["user_" + str(user)]["name"]:
			print("duplicado")
			return

	# create a new user
	if not user_txt.text in g.app.values() or not password_txt.text in g.app.values():
			
		g.app["user_" + str(g.users)] = {}
		g.app["user_" + str(g.users)]["name"] = String(user_txt.text)
		g.app["user_" + str(g.users)]["password"] = String(password_txt.text)
		
		g.app["user_" + str(g.users)]["cube"] = {}
		g.app["user_" + str(g.users)]["cube"]["cube_color"] = "#ffffff"
		
		g.app["user_" + str(g.users)]["cube"]["cube_scale"] = {}
		g.app["user_" + str(g.users)]["cube"]["cube_scale"]["cube_scale_x"] = 1
		g.app["user_" + str(g.users)]["cube"]["cube_scale"]["cube_scale_y"] = 1
		
	user_txt.text = ""
	password_txt.text = ""
	
	g.save_data()

func _on_enter_pressed():
	try_new_user_creation()	

func _on_user_txt_text_entered(_new_text):
	if password_txt.text.length() > 2:
		try_new_user_creation()
	
func _on_password_txt_text_entered(_new_text):
	try_new_user_creation()

func _on_manage_users_pressed():
	get_tree().change_scene("res://rsc/user_managment/user_managment.tscn")


