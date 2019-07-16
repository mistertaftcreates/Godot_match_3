extends TextureButton

enum {add_to_counter, make_color_bomb, destroy_piece}

onready var number_label = $NumberLabel

var number
var active = false
var used = false

# Texture Stuff
var active_texture
export (Texture) var add_to_counter_texture
export (Texture) var make_color_bomb_texture
export (Texture) var destroy_piece_texture
var type = ""

signal used
signal reset_others

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func check_active(is_active, booster_type, number_active):
	if is_active:
		if booster_type == "Color Bomb":
			texture_normal = make_color_bomb_texture
			type = "Color Bomb"
		elif booster_type == "Add To Counter":
			texture_normal = add_to_counter_texture
			type = "Add To Counter"
		elif booster_type == "Destroy Piece":
			texture_normal = destroy_piece_texture
			type = "Destroy Piece"
		number_label.text = String(number_active)
		number = number_active
	else:
		texture_normal = null
		type = ""

func booster_pressed(new_type):
	if new_type == type:
		if !used:
			use_booster()
		else:
			undo_booster()
	else:
		undo_booster()

func use_booster():	
	if number > 0:
		used = true
		number -= 1
		number_label.text = String(number)
		emit_signal("used")
	if number == 0:
		self.modulate = Color(0.5, 0.5, 0.5, 0.5)

func undo_booster():
	used = false
	number += 1
	number_label.text = String(number)
	self.modulate = Color(1, 1, 1, 1)

func _on_Booster1_pressed():
	booster_pressed(type)
	emit_signal("reset_others")

func _on_Booster2_pressed():
	booster_pressed(type)
	emit_signal("reset_others")

func _on_Booster3_pressed():
	booster_pressed(type)
	emit_signal("reset_others")

func _on_bottom_ui_undo_booster(booster_type):
	"""
	if type == booster_type:
		undo_booster()
	"""
	pass

func _on_bottom_ui_consume_booster(booster_type):
	if type == booster_type:
		used = false


func _on_Booster1_reset_others():
	if used:
		undo_booster()
	pass # Replace with function body.


func _on_Booster2_reset_others():
	if used:
		undo_booster()
	pass # Replace with function body.


func _on_Booster3_reset_others():
	if used:
		undo_booster()
	pass # Replace with function body.
