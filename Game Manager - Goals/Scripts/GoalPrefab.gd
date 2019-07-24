extends TextureRect

var current_number = 0
var max_value
var goal_value = ""
var goal_texture 
onready var goal_label = $VBoxContainer/Label
onready var this_texture = $VBoxContainer/TextureRect

func set_goal_values(new_max, new_texture, new_value):
	if !this_texture:
		this_texture = $VBoxContainer/TextureRect
	if !goal_label:
		goal_label = $VBoxContainer/Label
	this_texture.texture = new_texture
	max_value = new_max
	goal_value = new_value
	goal_label.text = "" + String(current_number) + "/" + String(max_value)

func update_goal_values(goal_type):
	if goal_type == goal_value:
		current_number += 1
		if current_number <= max_value:
			goal_label.text = "" + String(current_number) + "/" + String(max_value)