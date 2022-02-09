extends Control

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
	
func _on_exit_pressed():
	get_tree().change_scene("res://rsc/user_managment/user_managment.tscn")
