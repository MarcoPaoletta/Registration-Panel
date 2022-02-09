# Registration System
* Proyecto en el cual se crean usuarios. Cada usuario tiene destinado un cubo y puede cambiar distintas propiedades que son almacenadas en un archivo JSON
* El color y el tamaño del cubo son algunas cosas que cada usuario puede modificar
* La aplicacion va a detectar si el usuario ya esta creado y asi evitar duplicarlo

---

# Script global
* Script [global.gd](https://github.com/MarcoPaoletta/Registration-System/blob/main/rsc/global/global.gd) el cual almacena variables y funciones globales, es decir, que se pueden acceder y ejecutar en cualquier script

```gdscript
var current_user: String

var users: int

var app: Dictionary = { }

var path = "user://data.json"

func _process(_delta):
	users = app.keys().size()

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
```

* current_user: String: determina cual es el usuario actual para cambiar las propiedades de su cubo
* users: int: almacena el tamaño de las keys del diccionario, es decir, user_0, user_1, user_2, etc
* app: Dictionary: diccionario principal, en un inicio vacio, en el cual se almacenan todos los datos

* El resto del archivo es para el manejo del sistema de guardado y cargado de datos

---

# Creacion de usuario
* Script [registration_panel.gd](https://github.com/MarcoPaoletta/Registration-System/blob/main/rsc/registration_panel/registration_panel.gd) en el cual se crean los usuarios

```gdscript
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
```

* Si la longitud del texto de la contraseña es menor a 2, lo cual seria una contraseña sumamente predicible, evitamos la creacion de un nuevo usuario ejecutando ejecutando [return](https://godotengine.org/qa/41233/how-to-break-a-function#:~:text=The%20break%20keyword%20in%20most,just%20use%20the%20return%20keyword.)
* Para cada usuario creado, si el texto del usuario ya existe, evitamos la creacion de un nuevo usuario ejecutando ejecutando [return]
* En caso contrario de todo lo anterior, creamos un nuevo [diccionario](https://docs.godotengine.org/es/stable/classes/class_dictionary.html) con el numero de usuario, agregamos una key para el nombre de usuario que sera el texto del usuario y otra para la contraseña que sera el texto del usuario. Ademas, dentro del mismo diccionario creamos otro el cual va a almacenar las propiedades del cubo como el color. Por ultimo, dentro del diccionario del cubo, agregamos otro que almacenara su escala en el indice X e Y 
* Vaciamos el texto del usuario y de la contraseña
* Guardamos

---

# Manejo de los usuarios
* Script [user_managment.gd](https://github.com/MarcoPaoletta/Registration-System/blob/main/rsc/user_managment/user_managment.gd) 

```gdscript
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
```

* Cargamos los datos
* Para cada usuario creado, establecemos cual es el usuario actual (esta informacion la vamos a usar mas adeltante), creamos un boton, le conectamos la señal pressed a una funcion, lo agregamos a un grupo de los botones y su nombre va a ser el usuario actual. Creamos un contenedor y dentro de este agregamos labels con el nombre y contraseña del usuario
* Para la funcion que identifica cuando un boton es presionado, obtenemos los nodos de los botones (que estaban presentes en el grupo buttons) y si esta siendo presionado, el usuario actual va a ser el nombre del boton presioando

---

# Aplicacion para cambiar las propiedades del cubo

* Script [app.gd](https://github.com/MarcoPaoletta/Registration-System/blob/main/rsc/app/app.gd) 

```gdscript
func _ready():
	g.load_data()
	
	$cube.color = g.app[g.current_user]["cube"]["cube_color"]
	$cube.rect_scale.x = g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_x"]
	$cube.rect_scale.y = g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_y"]
	
	$cube_html.text = g.app[g.current_user]["cube"]["cube_color"]
	
	$cube_scale.text = "Cube scale: X" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_x"]) + " , Y" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_y"])
	
	$current_user.text = "The user currently being changed is: " + g.current_user.capitalize() + " , and its name is: " + g.app[g.current_user]["name"]
	
	$color_picker_button.color = g.app[g.current_user]["cube"]["cube_color"]
	
	$size_x.value = $cube.rect_scale.x
	$size_y.value = $cube.rect_scale.y
	
func _on_color_picker_button_color_changed(color):
	$cube.color = color
	g.app[g.current_user]["cube"]["cube_color"] = color.to_html()
	$cube_html.text = "#" + color.to_html()

func _on_size_x_value_changed(value):
	$cube.rect_scale.x = value
	g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_x"] = value
	$cube_scale.text = "Cube scale: X" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_x"]) + " , Y" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_y"])

func _on_size_y_value_changed(value):
	$cube.rect_scale.y = value
	g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_y"] = value
	$cube_scale.text = "Cube scale: X" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_x"]) + " , Y" + str(g.app[g.current_user]["cube"]["cube_scale"]["cube_scale_y"])
```

* Cargamos los datos
* Actualizamos valores dependiendo de los datos guardados tales como el color del cubo, escala, entre otros
* Si se cambia el color en el color picker, el color del cubo va a ser igual al nueo color del color picker, actualizamos el dato en el diccionario en formato html, es decir, #ffffff y el texto de una etiqueta que marca el color actual del cubo
* Si se cambia el valor de algun slider, ya sea de X o de Y, cambiamos la escala del cubo, actualizamos los datos del diccionario y cambiamos el texto de una etiqueta que marca la escala actual del cubo

---

# Descargar Godot Engine e importar el proyecto
---

## Descargar Godot Engine

* Accedemos al sitio oficial de [Godot Engine](https://godotengine.org/download) en la parte de descargas
* Seleccionamos nuestro sistema operativo
* Descargamos la **Standard version**
* Extraemos el archivo comprimido
* Esto nos dejara el ejecutable de Godot Engine

---

## Importar el proyecto

* Una vez descargado los archivos del proyecto, movemos la carpeta a una ruta de preferencia
* Abrimos Godot Engine y en la parte de la derecha buscamos el boton **Import** o **Importar**
* Escribimos la ruta del proyecto o buscamos manualmente en la carpeta del proyecto el archivo project.godot 
* Nos abrira el projecto y podremos ejecutarlo desde ahi tocando **F5** o en la parte superior derecha con el boton de play