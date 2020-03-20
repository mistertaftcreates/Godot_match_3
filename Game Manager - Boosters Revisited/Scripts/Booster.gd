extends TextureButton

"""
This is a script to hold information pertaining to boosters.
At the moment the only boosters are: Color bombs, adding to the 
counter, and destroying a specific piece.  
"""

enum {add_to_counter, make_color_bomb, destroy_piece}
var state

var active = false

# Texture Stuff
var active_texture
export (Texture) var add_to_counter_texture
export (Texture) var make_color_bomb_texture
export (Texture) var destroy_piece_texture
var type = ""


func check_active(is_active, booster_type):
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
	else:
		texture_normal = null
		type = ""

